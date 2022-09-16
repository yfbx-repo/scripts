#!/bin/bash
# 
#  MAC部署本地服务器：
#  1. 开启MAC自带的apache服务 sudo apachectl start
#  2. 打开 http://127.0.0.1/ 验证服务是否开启成功
#  3. 默认服务目录：/Library/WebServer/Documents,
#     可在/etc/apache2/httpd.conf文件和/private/etc/apache2/users/用户名.conf文件,修改服务目录
#  
#  MAC外网域名映射：
#  1. 注册 ngrok, 获取token,官网地址：https://ngrok.com/download
#  2. 安装 ngrok: brew install ngrok/ngrok/ngro
#  3. 配置 token: ngrok config add-authtoken <token>
#  4. 启动 ngrok http localhost:80 可在控制台看到域名
#  域名不是固定的，每次启动都会变化，付费可自定义域名
# 
#  脚本用到的工具:
#  1. jq         用户格式化JSON,JSON解析
#  2. qrencode   用于生成二维码
# 
# ./pack_server.sh [debug/release]
#
set -e

host="https://a343-124-77-86-98.jp.ngrok.io"
branch=$(git symbolic-ref --short HEAD)

# 参数
mode="debug"
if [[ -n $1 ]]; then
  mode=$1
fi


# 打包
flutter clean
flutter pub get
flutter build apk --$mode -v

# 查找APK
apks=()
files=$(find . -name "*.apk")
for f in ${files}; do
  apks[${#apks[*]}]=$f
done

apk=${apks[0]}
file_name=$(basename $apk)

echo
if [ -z $apk ]; then
  echo "APK Not Found!"
  exit 1
else
  echo "APK info:"
  echo "$branch"
  echo "$apk"
fi
echo

# 复制到服务目录
cp $apk /Users/edward/webserver

# 文件链接
href="$host/$file_name"
echo "APK: $href"
 
# 生成二维码
qrname=${file_name%%.*}
image="/Users/edward/webserver/$qrname.png"
qrencode -o $image $href


# 上传二维码到飞书
token_result=$(curl -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal/" \
-H "Content-Type: application/json" \
-d "{
    \"app_id\": \"cli_a1ceacbb0eb8900b\",
    \"app_secret\": \"eEdqUP0PJlhSJIf9Dvq65S4Owr0NPXIb\"
}")
token=$(echo $token_result | jq -r '.tenant_access_token')

image_result=$(curl -X POST "https://open.feishu.cn/open-apis/image/v4/put/" \
-H "Authorization:Bearer $token" \
-F "image_type=message" \
-F "image=@$image"
)
image_key=$(echo $image_result | jq -r '.data.image_key')


# 飞书消息
echo
echo "发送飞书消息..."
echo
curl "https://open.feishu.cn/open-apis/bot/v2/hook/572431e5-5871-41bc-952a-0a467548dac1" \
--header "Content-Type: application/json" \
--data-raw "
{
    \"msg_type\": \"post\",
    \"content\": {
        \"post\": {
            \"zh_cn\": {
                \"title\": \"壹品仓储(员工版)\",
                \"content\": [
                    [
                        {
                            \"tag\": \"img\",
                            \"image_key\": \"$image_key\",
                            \"width\": 300,
                            \"height\": 300
                        }
                    ],
                    [
                        {
                            \"tag\": \"a\",
                            \"text\": \"$file_name\",
                            \"href\": \"$href\"
                        }
                    ],
                    [
                        {
                            \"tag\": \"text\",
                            \"text\": \"branch: $branch\"
                        }
                    ]
                ]
            }
        }
    }
}
"
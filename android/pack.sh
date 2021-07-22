#
# CI 打包
# 命令格式：./pack.sh debug Yuxiaor
#

apiKey="6d040f4231bcda1dd5613cd27284f9bc"
pgyer="https://www.pgyer.com/3sVc"
imageKey="img_v2_2827ce84-1281-4036-8539-2b812cc9525g"

# 默认参数
type="debug"
flavor="Yuxiaor"
branch=$(git symbolic-ref --short HEAD)

#传入参数
if [[ -n $1 ]]; then
  type=$1
fi

if [[ -n $2 ]]; then
  flavor=$2
fi

if [ $type = "release" ]; then
  buildType="Release"
  apkPath="./app/build/outputs/apk/$flavor/$type"
else
  buildType="Debug"
  apkPath="./app/build/outputs/apk/$flavor/$type"
fi

# ----------------------------------------

# 打包
./gradlew clean
./gradlew "assemble$flavor$buildType"

# 查找APK
files=$(ls $apkPath)
for f in ${files}; do
  if [ "${f:0-3:3}" = "apk" ]; then
    file=$f
    break
  fi
done
apk="$apkPath/$file"

if [ -z "$file" ]; then
  echo
  echo "打包失败！！！"
  echo
  read -r
  exit 1
fi

echo
echo "打包成功"
echo "$apk"
echo

# 上传蒲公英
echo
echo "上传到蒲公英..."
echo
curl "https://www.pgyer.com/apiv2/app/upload" \
-F "_api_key=$apiKey" \
-F "file=@$apk"

if [ $flavor != "Yuxiaor" ]; then
  echo
  echo "只有打包寓小二会发送飞书消息，其他渠道不发送飞书消息。"
  echo "若上传到蒲公英成功，则上面返回结果中的链接即为二维码链接。"
  echo
  read -r
  exit 1
fi

# 飞书消息
echo
echo "发送飞书消息..."
echo
text="[
  {\"tag\": \"text\",\"text\": \"branch: $branch\"}
]"

img="[{
\"tag\": \"img\",
\"image_key\": \"$imageKey\",
\"width\": 300,
\"height\": 300
}]"

url="[{
\"tag\": \"a\",
\"text\": \"$file\",
\"href\": \"$pgyer\"
}]"

raw="{
  \"msg_type\": \"post\",
  \"content\": {
    \"post\": {
        \"zh_cn\":{\"title\": \"Android APK\",\"content\": [$img,$url,$text]}
    }
  }
}"

curl "https://open.feishu.cn/open-apis/bot/v2/hook/13bad1ac-7482-4aa4-a744-a5db6ca119b1" \
--header "Content-Type: application/json" \
--data-raw "$raw"

# 结束
read -r

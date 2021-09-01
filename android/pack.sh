#
# CI 打包
# ./pack.sh [release/debug] [Yuxiaor] [branch]
#

api_key="6d040f4231bcda1dd5613cd27284f9bc"
image_key="img_v2_2827ce84-1281-4036-8539-2b812cc9525g"
href="https://www.pgyer.com/3sVc"

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

if [[ -n $3 ]]; then
  branch=$3
  git checkout $3
fi

if [ $type = "release" ]; then
  buildType="Release"
else
  buildType="Debug"
fi

# 打包
git pull
./gradlew clean
./gradlew "assemble$flavor$buildType"

if [ $? -eq 0 ]; then
  echo "打包成功!"
else
  echo "打包失败!"
  exit 1
fi

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

# 上传蒲公英
echo
echo "上传到蒲公英..."
echo
curl "https://www.pgyer.com/apiv2/app/upload" -F "_api_key=$api_key" -F "file=@$apk"

if [ $? -eq 0 ]; then
  echo "上传成功!"
else
  echo "上传失败!"
  exit 1
fi

# 飞书消息
echo
echo "发送飞书消息..."
echo

curl "https://open.feishu.cn/open-apis/bot/v2/hook/13bad1ac-7482-4aa4-a744-a5db6ca119b1" \
--header "Content-Type: application/json" \
--data-raw "
{
    \"msg_type\": \"post\",
    \"content\": {
        \"post\": {
            \"zh_cn\": {
                \"title\": \"Android APK\",
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

# 结束
exit 0

#
# CI 打包
#

# 输入打包渠道
flavors[0]="Yuxiaor"
flavors[1]="Hazuk"
flavors[2]="Zudashi"
flavors[3]="Jinmao"
flavors[4]="Fengle"
flavors[5]="Jinxiu"
flavors[6]="Yiguanjia"
flavors[7]="Qianbs"
flavors[8]="Hangzhu"
flavors[9]="Yunjia"
flavors[10]="Keru"
flavors[11]="Ziyuan"
flavors[12]="Fangzhuzhu"
flavors[13]="Nuanhu"
flavors[14]="Liwo"

echo
echo "----- 选择打包渠道-----"
echo "  1.寓小二"
echo "  2.哈租客管家"
echo "  3.租大师管家端"
echo "  4.金茂公寓管家"
echo "  5.丰乐伙伴"
echo "  6.锦绣年华"
echo "  7.易管家"
echo "  8.仟佰顺管家"
echo "  9.杭驻管家"
echo "  10.云家"
echo "  11.客如"
echo "  12.需丰服务"
echo "  13.房猪猪伙伴"
echo "  14.暖虎伙伴"
echo "  15.哩窝管家"
echo
read -r -p "Flavor Name: " flavorIndex
flavor=${flavors[$flavorIndex - 1]}

# 输入打包类型
echo
echo "----- 选择打包类型-----"
echo "  1.debug"
echo "  2.release"
echo
read -r -p "Build Type: " buildTypeIndex
if [ $buildTypeIndex == 2 ]; then
  buildType="Release"
  apkPath="./app/build/outputs/apk/$flavor/release"
else
  buildType="Debug"
  apkPath="./app/build/outputs/apk/$flavor/debug"
fi

# git 分支
echo
echo "当前分支：$(git symbolic-ref --short HEAD)"
read -r -p "分支名(不填默认当前分支): " branchName
echo
if [[ -n $branchName ]]; then
  git checkout $branchName
fi
git pull
branch=$(git symbolic-ref --short HEAD)

# 描述
echo
read -r -p "更新内容(可不填): " desc
echo

# ----------------------------------------

# 打包
./gradlew clean
./gradlew "assemble$flavor$buildType"

# 查找APK
files=$(ls $apkPath)
for f in ${files}; do
  if [ "${f:0-3:3}" = "apk" ]; then
    file=$f
  fi
done
apk="$apkPath/$file"

git checkout develop

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
-F "_api_key=6d040f4231bcda1dd5613cd27284f9bc" \
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
  {\"tag\": \"text\",\"text\": \"branch: $branch\"},
  {\"tag\": \"text\",\"text\": \"$desc\"}
]"

img="[{
\"tag\": \"img\",
\"image_key\": \"img_v2_2827ce84-1281-4036-8539-2b812cc9525g\",
\"width\": 300,
\"height\": 300
}]"

url="[{
\"tag\": \"a\",
\"text\": \"$file\",
\"href\": \"https://www.pgyer.com/3sVc\"
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

# 
# Android AAR
# 

set -e

MODE='debug'
BRANCH=$(git symbolic-ref --short HEAD)
# Version
PACKAGE=$(grep "androidPackage" pubspec.yaml | cut -d':' -f2 | sed 's/^[ \t]*//g')
VERSION_NAME=$(grep "version" pubspec.yaml | cut -d':' -f2 | sed 's/^[ \t]*//g')
VERSION_CODE=$(git rev-list --count HEAD)
VERSION="$VERSION_NAME.$VERSION_CODE"

# mode
if [[ -n $1 ]]; then
  MODE=$1
fi

# build type
if [ $MODE = "release" ]; then
  buildType="--no-debug"
  MAVEN='https://packages.aliyun.com/maven/repository/2105726-release-0ODHcU'
  MAVEN_ID="rdc-releases"
else
  buildType="--no-release"
  MAVEN='https://packages.aliyun.com/maven/repository/2105726-snapshot-nsLuXp'
  MAVEN_ID="rdc-snapshots"
fi

# 打包
flutter clean
flutter pub get
flutter build aar --build-number $VERSION --no-pub --no-profile $buildType


# 上传到maven库
files=$(find . -name "*.pom")
for f in ${files}; do
  path=$(dirname $f)
  echo "上传：$path"
  pom=$f
  aar=$(find $path -name "*.aar")
  mvn deploy:deploy-file -e -q -DrepositoryId=$MAVEN_ID -Durl=$MAVEN -DpomFile=$pom -Dfile=$aar
done


# 飞书通知
FEISHU_TOKEN="572431e5-5871-41bc-952a-0a467548dac1"
curl -X POST "https://open.feishu.cn/open-apis/bot/v2/hook/$FEISHU_TOKEN" \
-H "Content-Type: application/json" \
-d "{
    \"msg_type\": \"post\",
    \"content\": {
        \"post\": {
            \"zh_cn\": {
                \"title\": \"Flutter AAR\",
                \"content\": [
                    [
                        {
                            \"tag\": \"text\",
                            \"text\": \"分支: $BRANCH\n\"
                        },
                        {
                            \"tag\": \"text\",
                            \"text\": \"build: $MODE\n\"
                        },
                        {
                            \"tag\": \"text\",
                            \"text\": \"version: $VERSION\n\"
                        },
                        {
                            \"tag\": \"text\",
                            \"text\": \"maven: \"
                        },
                        {
                            \"tag\": \"a\",
                            \"text\": \"'$PACKAGE:flutter_$MODE:$VERSION'\",
                            \"href\": \"$MAVEN\"
                        }
                    ]
                ]
            }
        }
    }
}"
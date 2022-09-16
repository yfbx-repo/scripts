 #!/bin/bash
#
# ./pack.sh [release/debug] [flavor]
#
#

set -e
app_type="android"
api_key="6d040f4231bcda1dd5613cd27284f9bc"
image_key="img_v2_3073d63c-ca3b-498e-a5c4-23405e9dc2ag"
branch=$(git symbolic-ref --short HEAD)
version_code=$(git rev-list --count HEAD)

# ---------------------------------------------------------------
# 参数
# ---------------------------------------------------------------
flavor="Ypc"
type="debug"

if [ -n "$1" ]; then
  type=$1
fi

if [ -n "$2" ];then
  flavor=$2
fi

if [ "$type" = "release" ]; then
    mode="Release"
  else
    mode="Debug"
fi

# ---------------------------------------------------------------
# 打包
# ---------------------------------------------------------------
if [ -e "./gradlew.bat" ];then
  ./gradlew clean
  ./gradlew "assemble$flavor$mode"
else
  echo "项目路径不正确，请将脚本放入项目根目录，或指定项目路径"
  exit 1
fi


# ---------------------------------------------------------------
# functions
# ---------------------------------------------------------------
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

logTitle() {
    log "-------------------------------- $* --------------------------------"
}

execCommand() {
    log "$@"
    result=$(eval $@)
}

#
# 查找APK
#
apks=()
files=$(find . -name "*.apk")
for f in ${files}; do
  apks[${#apks[*]}]="$f"
done

apk=${apks[0]}
file_name=$(basename "$apk")

if [ -z "$apk" ]; then
  log "APK Not Found!"
  exit 1
else
  logTitle "APK"
  log "分支: $branch"
  log "APK: $apk"
fi


# ---------------------------------------------------------------
# 获取上传凭证
# ---------------------------------------------------------------
logTitle "获取凭证"

execCommand "curl -s -F '_api_key=${api_key}' -F 'buildType=${app_type}' http://www.pgyer.com/apiv2/app/getCOSToken"

echo $result | jq .
endpoint=$(echo $result | jq -r '.data.endpoint')
key=$(echo $result | jq -r '.data.key')
signature=$(echo $result | jq -r '.data.params.signature')
[[ "${result}" =~ \"x-cos-security-token\":\"([\_A-Za-z0-9\-]+)\" ]] && x_cos_security_token=`echo ${BASH_REMATCH[1]}`

if [ -z "$key" ] || [ -z "$signature" ] || [ -z "$x_cos_security_token" ] || [ -z "$endpoint" ]; then
    log "get upload token failed"
    exit 1
fi

# ---------------------------------------------------------------
# 上传文件
# ---------------------------------------------------------------

logTitle "上传文件"

execCommand "curl -s -o /dev/null -w '%{http_code}' --form-string 'key=${key}' --form-string 'signature=${signature}' --form-string 'x-cos-security-token=${x_cos_security_token}' -F 'file=@${apk}' ${endpoint}"

if [ $result -ne 204 ]; then
    log "Upload failed"
    exit 1
fi

# ---------------------------------------------------------------
# 检查结果
# ---------------------------------------------------------------

logTitle "检查结果"

for i in {1..60}; do
    execCommand "curl -s http://www.pgyer.com/apiv2/app/buildInfo?_api_key=${api_key}\&buildKey=${key}"
    code=$(echo $result | jq -r '.code')
    if [ $code -eq 0 ]; then
        buildShortcutUrl=$(echo $result | jq -r '.data.buildShortcutUrl')
        echo $result | jq .
        break
    else
        sleep 1
    fi
done

href="https://www.pgyer.com/$buildShortcutUrl"
log "下载地址: $href"

logTitle "发送飞书消息..."
params="{
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
                              \"width\": 200,
                              \"height\": 200
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
                              \"text\": \"type: $type\"
                          }
                      ],
                      [
                          {
                              \"tag\": \"text\",
                              \"text\": \"build: $version_code\"
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
  }"
api_feishu="https://open.feishu.cn/open-apis/bot/v2/hook/572431e5-5871-41bc-952a-0a467548dac1"
curl $api_feishu --header "Content-Type: application/json" --data-raw "$params" | jq .
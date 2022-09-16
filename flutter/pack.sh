#!/bin/bash
#
# CI 打包
# ./pack [debug/release]
#
set -e
app_type="android"
api_key="6d040f4231bcda1dd5613cd27284f9bc"
token="572431e5-5871-41bc-952a-0a467548dac1"
image_key="img_v2_154c47be-2894-4b55-91bd-4b83339cb3dg"
branch=$(git symbolic-ref --short HEAD)
# Version
VERSION_NAME=$(grep "version" pubspec.yaml | cut -d':' -f2 | sed 's/^[ \t]*//g')
VERSION_CODE=$(git rev-list --count HEAD)
VERSION="$VERSION_NAME.$VERSION_CODE"

# 参数
mode="debug"
if [[ -n $1 ]]; then
  mode=$1
fi



# ---------------------------------------------------------------
# 打包
# ---------------------------------------------------------------
flutter clean
flutter pub get
flutter build apk --$mode -v

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


# ---------------------------------------------------------------
# 查找APK
# ---------------------------------------------------------------
apks=()
files=$(find . -name "*.apk")
for f in ${files}; do
  apks[${#apks[*]}]=$f
done

apk=${apks[0]}
file_name=$(basename $apk)

if [ -z $apk ]; then
  log "APK Not Found!"
  exit 1
else
  logTitle "APK"
  log "分支: $branch"
  log "路径: $apk"
fi


# ---------------------------------------------------------------
# 获取上传凭证
# ---------------------------------------------------------------
logTitle "获取凭证"

execCommand "curl -s -F '_api_key=${api_key}' -F 'buildType=${app_type}' http://www.pgyer.com/apiv2/app/getCOSToken"

log $result

[[ "${result}" =~ \"endpoint\":\"([\:\_\.\/\\A-Za-z0-9\-]+)\" ]] && endpoint=`echo ${BASH_REMATCH[1]} | sed 's!\\\/!/!g'`
[[ "${result}" =~ \"key\":\"([\.a-z0-9]+)\" ]] && key=`echo ${BASH_REMATCH[1]}`
[[ "${result}" =~ \"signature\":\"([\=\&\_\;A-Za-z0-9\-]+)\" ]] && signature=`echo ${BASH_REMATCH[1]}`
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
    [[ "${result}" =~ \"code\":([0-9]+) ]] && code=`echo ${BASH_REMATCH[1]}`
    if [ $code -eq 0 ]; then
        [[ "${result}" =~ \"buildShortcutUrl\":\"([\:\_\.\/\\A-Za-z0-9\-]+)\" ]] && buildShortcutUrl=`echo ${BASH_REMATCH[1]} | sed 's!\\\/!/!g'`
        echo $result
        break
    else
        sleep 1
    fi
done
 
href="https://www.pgyer.com/$buildShortcutUrl"
log "下载地址: $href"


# ---------------------------------------------------------------
# 发送飞书消息
# ---------------------------------------------------------------
logTitle "发送飞书消息"
curl "https://open.feishu.cn/open-apis/bot/v2/hook/$token" \
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
                            \"text\": \"build: $mode\"
                        }
                    ],
                    [
                        {
                            \"tag\": \"text\",
                            \"text\": \"branch: $branch\"
                        }
                    ],
                    [
                        {
                            \"tag\": \"text\",
                            \"text\": \"version: $VERSION\"
                        }
                    ]
                ]
            }
        }
    }
}
"
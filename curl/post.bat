@echo off

set token=%1
set markdown=%2

set json="{\"msgtype\": \"markdown\",\"markdown\": {\"title\": \"Android APK\",\"text\":%markdown%}}"

curl -v https://oapi.dingtalk.com/robot/send?access_token=%token% -H "Content-Type:application/json" -d %json%


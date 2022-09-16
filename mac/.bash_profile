export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FLUTTER=/Users/edward/flutter/Flutter/bin
export DART_SDK=${FLUTTER}/cache/dart-sdk/bin
export ANDROID_HOME=/Users/edward/Library/Android/sdk
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.12.jdk/Contents/Home
export OSS=/Users/edward/oss

export PATH=${PATH}:/usr/local/bin/brew
export PATH=${PATH}:/usr/bin/dirname
export PATH=${PATH}:${FLUTTER}
export PATH=${PATH}:${DART_SDK}
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH=${PATH}:$HOME/.pub-cache/bin
export PATH=${PATH}:$OSS

# Visual Studio Code
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
# Android Studio
alias studio="/Applications/Android\ Studio.app/Contents/MacOS/studio"
# 查看本机安装的所有ava版本
alias javav="/usr/libexec/java_home -V"

alias profile="code ~/.bash_profile"
alias m2="code ~/.m2/settings.xml"

alias wms="code ~/workspace/wms_flutter"
alias ypc="code ~/workspace/ypc_flutter"
alias python="/usr/local/bin/python3"

# 清除DNS缓存
alias refreshDNS="sudo killall -HUP mDNSResponder"

# 将目录及其子目录的拥有者改为当前用户
function own(){
    sudo chown -R $(whoami) $1
}

# 上传文件到阿里云 /static/store 目录下
function oss(){
  if [ -z $1 ]; then
    echo "command: oss <file>"
    return
  fi

  file_name=$(basename "$1")
  ossutilmac64 cp $1 oss://ypcang/static/store/$file_name

  echo
  echo "下载链接："
  echo "https://img.shanghaicang.com.cn/static/store/$file_name"
  echo 
}

# 生成二维码
function qr(){
  if [ -z $1 ]; then
    echo "command: qr <content>"
    return
  fi
  echo $1 | qrencode -o - -t UTF8
}

# 隐私合规检测
function hook(){
  if [ -z $1 ]; then
    echo "command: hook <package name> [output file]"
    return
  fi
    python3 ~/camille/camille.py $1 -ns -f "隐私合规.xls"
}

# 刷新环境
function refresh(){
    source ~/.bash_profile
}

# JAVA
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
export PATH=$PATH:$JAVA_HOME/bin

# Flutter
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH=$PATH:/home/edward/tools/flutter/bin

# niet
export PATH=$PATH:/home/edward/.local/bin

# ADB
export PATH=$PATH:/home/edward/Android/Sdk/platform-tools

# 脚本
export PATH=$PATH:/home/edward/scripts

# Android Studio
function studio(){
    setsid /home/edward/tools/android-studio/bin/studio.sh $1
}

# 别名
# 打开路径或文件
alias open=xdg-open
alias cls='clear'
alias profile='code ~/.bash_profile'
alias refresh='source ~/.bash_profile'

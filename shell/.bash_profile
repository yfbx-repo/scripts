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

# git 添加tag
function tag-add(){
  git tag -a $1 -m $1
  git push --tags
}
# git 删除tag
function tag-del(){
  git tag -d $1
  git push origin :refs/tags/$1
}
# git 查看远程tag
function tag-remote(){
  git ls-remote --tags
}
# git commit
function cm(){
  git add -A
  git status
  git commit -m $1
}

# git 批量删除本地分支,参数为筛选条件
function branch_del(){
  if [ -z $1 ]; then
    echo "command: branch_del <filter>"
    return
  fi
  git branch -a | grep "$1" | xargs git branch -D
}

# 批量删除远程分支,参数为筛选条件
function branch_del_remote(){
   if [ -z $1 ]; then
    echo "command: branch_del_remote <filter>"
    return
  fi
  git branch -r | grep  "$1" | sed 's/origin\///g' | xargs -I {} git push origin -d {}
}

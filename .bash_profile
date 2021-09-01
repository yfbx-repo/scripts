# 
# bash profile
# 

alias cls='clear'
alias profile='code ~/.bash_profile'
alias refresh='source ~/.bash_profile'
# 
alias maven='start ~/.m2/repository'
alias jq='/d/tools/jq-shell/jq-win64.exe'

# echo 红色字
function err(){
  echo -e "\033[31m$1\033[0m"
}

# echo 绿色字
function info(){
  echo -e "\033[32m$1\033[0m"
}

# 打开Android Studio
function as(){
  start /d/tools/AndroidStudio/bin/studio64.exe $1
}

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
    err "command: branch_del <filter>"
    return
  fi
  git branch -a | grep "$1" | xargs git branch -D
}

# 批量删除远程分支,参数为筛选条件
function branch_del_remote(){
   if [ -z $1 ]; then
    err "command: branch_del_remote <filter>"
    return
  fi
  git branch -r | grep  "$1" | sed 's/origin\///g' | xargs -I {} git push origin -d {}
}


# 
# flutter module 打包aar
# 
function aar(){
  if [ -z $1 ]; then
    err "command: aar <build number>"
    return
  fi

  version=$1
  
  flutter clean
  flutter pub get
  flutter build aar --no-release --no-profile --build-number $version
  
  if [ $? -eq 0 ]; then
    info "打包成功!"
  else
    err "打包失败!"
    return
  fi
  
  cp -r -f build/host/outputs/repo/*  ~/.m2/repository
  
  package=$(niet flutter.module.androidPackage pubspec.yaml)
  
  info "
    repositories {
        mavenLocal()
    }
  
    dependencies {
       debugImplementation '$package:flutter_debug:$version'
    }
    "
}


#
# 使用 aar 文件创建本地 maven 仓库
#
function mvnaar(){
  # $# 参数个数
  # -ne 不等于
  # -eq 相等
  if [ $# -ne 4 ]; then
    err "command: mvnaar <aar> <group> <artifact> <version>"
    return
  fi

  aar=$1
  group=$2
  artifact=$3
  version=$4
  
  mvn deploy:deploy-file \
  -Dfile="$aar" \
  -DgroupId="$group" \
  -DartifactId="$artifact" \
  -Dversion="$version" \
  -Durl="file://."
  
  if [ $? -eq 0 ]; then
    info "生成成功"
    info "implementation '${group}:${artifact}:${version}'"
  else
    err "生成出错"
  fi  
}

# 
# 上传到远程Maven库
# 
function mvnup(){
  if [ -z $1 ]; then
    err "command: mvnup <pom/aar>" 
    return
  fi 
  
  MAVEN='http://nexus.dev.yuxiaor.cn/repository/mobile/' 
  
  path=$(dirname $1)
  pom=$(find $path -name "*.pom")
  aar=$(find $path -name "*.aar")
  
  mvn deploy:deploy-file -e -q -DrepositoryId=yxr -Durl=$MAVEN -DpomFile=$pom -Dfile=$aar
  
  if [ $? -eq 0 ]; then
    echo "Succeed!"
  else
    echo "Failed!"
  fi  
}
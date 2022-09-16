#!/bin/bash
# 
# aar上传到远程Maven库
# ./maven_upload <aar>
# 
set -e

# Maven地址
MAVEN="https://packages.aliyun.com/maven/repository/2278381-snapshot-RinC7T"
# 仓库Id
REPOSITORY_ID="rdc-snapshots"
# 输入参数 aar文件
AAR=$1

# 检查aar后缀
if [ ${AAR##*.} != "aar" ];then
  echo "$AAR is invalid!"
  exit 1
fi

# 检查文件
if [ -f $AAR ];then
  basename $AAR
else
  echo "$AAR is not found or not valid!"
  exit 1  
fi

# 查找同目录下pom文件和aar文件
path=$(dirname $AAR)
pom=$(find $path -name "*.pom")
aar=$(find $path -name "*.aar")

# 上传
mvn deploy:deploy-file -e -q -DrepositoryId=$"REPOSITORY_ID" -Durl="$MAVEN" -DpomFile="$pom" -Dfile="$aar"

if [ $? -eq 0 ]; then
  echo "Succeed!"
else
  echo "Failed!"
fi  


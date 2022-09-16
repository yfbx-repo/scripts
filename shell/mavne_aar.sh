#!/bin/bash
#
# 为aar生成pom文件
# ./maven_aar.sh  <aar> <com.xxx.name:1.0.0>
#

set -e

AAR=$1
PACKAGE=$2

# 检查后缀
if [ ${AAR##*.} != "aar" ];then
  echo "$AAR is invalid!"
  exit 1
fi

# 检查文件 
if [ -f $AAR ];then
  echo "aar: $(basename $AAR)"
else
  echo "$AAR is not found or not valid!"
  exit 1  
fi

# 从package中解析 group、artifact、version
group=${PACKAGE%%:*}
echo "group: $group"
tmp=${PACKAGE#*:}
artifact=${tmp%:*}
echo "artifact: $artifact"
version=${PACKAGE##*:}
echo "version: $version"


# 生成
mvn deploy:deploy-file \
-Dfile="$AAR" \
-DgroupId="$group" \
-DartifactId="$artifact" \
-Dversion="$version" \
-Durl="file://."

if [ $? -eq 0 ]; then
  echo "生成成功"
  echo "implementation '${group}:${artifact}:${version}'"
else
  echo "生成出错"
fi  

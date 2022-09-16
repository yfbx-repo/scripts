#!/bin/bash
# 
# flutter生成debug模式aar,本地maven库引用
# 
PACKAGE=$(niet flutter.module.androidPackage pubspec.yaml)
VERSION_NAME=$(niet version pubspec.yaml)
VERSION_CODE=$(git rev-list --count HEAD)
VERSION="$VERSION_NAME.$VERSION_CODE"


# ---------------------------------------------------------------
# functions
# ---------------------------------------------------------------
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

logTitle() {
    log "-------------------------------- $* --------------------------------"
}

logTitle "开始打包"

flutter clean
flutter pub get
flutter build aar --no-release --no-profile --build-number $VERSION


if [ $? -eq 0 ]; then
  log "打包成功!"
else
  log "打包失败!"
  exit 1
fi


logTitle "复制到本地Maven库"
cp -r -f build/host/outputs/repo/*  ~/.m2/repository

logTitle "Maven配置"
echo "
  repositories {
      mavenLocal()
  }

  dependencies {
     debugImplementation '$PACKAGE:flutter_debug:$VERSION'
  }
  "
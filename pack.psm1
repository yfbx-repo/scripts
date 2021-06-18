# 
# Android pack
# 


# build  aar for flutter project
function aar($buildNumber){
  if($branch -eq $null){
    echo "Build Number is Required!"
    return
  }
  $workDir = Get-Location
  # $buildNumber = git rev-list --count HEAD
  flutter clean
  flutter pub get
  flutter build aar --no-release --no-profile --build-number $buildNumber
  # 将生成的文件复制到指定文件夹，再推送到远程
  robocopy build\host\outputs\repo D:\maven /s
  cd D:\maven
  git add -A
  git commit -m $buildNumber
  git pull
  git push

  Write-Host "
  repositories {
      maven {
          url 'https://yfbx-repo.github.io/maven/'
      }
  }

  dependencies {
     debugImplementation 'com.yuxiaor.mobile.faraday:flutter_debug:$buildNumber'
  }

  " -ForegroundColor green

  cd $workDir
}


function phh{
  flutter build web
  robocopy build\web D:\demos\phh /s
  git add -A
  git commit -m "update"
  git pull
  git push
}

# 在指定分支打Yuxiaor debug包
# yxr feature/xxx
function yxr($branch,$desc) {
  if($branch -eq $null){
    echo "请指定分支：yxr feature/xxx"
    return
  }
  ssh ci@192.168.3.64 "./pack_apk.sh debug Yuxiaor $branch $desc"
}

# 在指定分支打指定渠道release包
# release Jinmao release/7.0.0
function release($flavor,$branch,$desc) {
  if($flavor -eq $null){
    echo "请指定渠道：release Yuxiaor feature/xxx"
    return
  }
  if($branch -eq $null){
    echo "请指定分支：release Yuxiaor feature/xxx"
    return
  }
  ssh ci@192.168.3.64 "./pack_apk.sh release $flavor $branch $desc"
}

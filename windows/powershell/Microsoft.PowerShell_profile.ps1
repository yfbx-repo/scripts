# 
# PowerShell 启动时加载默认配置脚本
# 
# 1. 以管理员身份运行PowerShell
# 2. 执行 set-ExecutionPolicy RemoteSigned 更改脚本执行策略
# 3. 配置脚本，执行 $profile 可以查看脚本路径
# 

# 导入其他模块。必须使用绝对路径 
Import-Module D:\\Documents\\PowerShell\\alias.psm1

# build  aar for flutter project
function aar($buildNumber){
  if($buildNumber -eq $null){
    printError "aar <build number>"
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

  printInfo "
  repositories {
      maven {
          url 'https://yfbx-repo.github.io/maven/'
      }
  }

  dependencies {
     debugImplementation 'com.yuxiaor.mobile.faraday:flutter_debug:$buildNumber'
  }

  "

  cd $workDir
}

# 在指定分支打Yuxiaor debug包
function yxr($branch) {
  if($branch -eq $null){
    printError "yxr <branch>"
    return
  }
  ssh ci@192.168.3.64 "./pack_apk.sh debug Yuxiaor $branch"
}

# 在指定分支打指定渠道release包
function release($flavor,$branch) {
  if($flavor -eq $null -or $branch -eq $null){
    printError "release <flavor> <branch>" 
    return
  }
  ssh ci@192.168.3.64 "./pack_apk.sh release $flavor $branch"
}

function phh{
  flutter build web
  robocopy build\web D:\demos\phh /s
  git add -A
  git commit -m "update"
  git pull
  git push
}

function phone{
  $wlan0 = adb shell netcfg | findStr wlan0
  echo $wlan0
  $test = $wlan0 -match '((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}'
  $ip = $matches[0]
  printInfo 'IP:'$ip -ForegroundColor green
  adb connect $ip
}


# 使用 aar 文件创建本地 maven 仓库
function maven($aar,$groupId,$artifactId,$version){
  if($aar -eq $null  -or $groupId -eq $null -or $artifactId -eq $null -or $version -eq $null){
    printError "maven <aar> <group> <artifact> <version>"
    return;
  }
  # -Durl="file://." 在当前目录生成文件，若填的是远程仓库地址，则直接上传到远程仓库
  mvn deploy:deploy-file -Dfile="$aar" -DgroupId="$groupId" -DartifactId="$artifactId" -Dversion="$version" -Durl="file://."
}

function printError($msg){
  Write-Host $msg -ForegroundColor red
}

function printInfo($msg){
  Write-Host $msg -ForegroundColor green
}


# 为PowerShell命令的配色，官方文档：https://docs.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption?view=powershell-7.1&viewFallbackFrom=powershell-6
Set-PSReadLineOption -Colors @{
    Command             = "#e5c07b"
    Number              = "#cdd4d4"
    Member              = "#e06c75"
    Operator            = "#e06c75"
    Type                = "#78b6e9"
    Variable            = "#78b6e9"
    Parameter           = "#e06c75"
    ContinuationPrompt  = "#e06c75"
    Default             = "#cdd4d4"
    Emphasis            = "#e06c75"
    #Error
    Selection           = "#cdd4d4"
    Comment             = "#cdd4d4"
    Keyword             = "#e06c75"
    String              = "#78b6e9"
}

function prompt{
    Write-Host("$pwd>")
    $path = $pwd.path
    "$ "
}

# 编码格式，避免中文乱码
chcp 65001
# 启动时清除微软广告
cls  
# 启动时打印字符画
cat D:\tools\auto_pack\tag.txt | Write-Host -ForegroundColor green
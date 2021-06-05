# 
# PowerShell 启动时加载默认配置脚本
# 
# 1. 以管理员身份运行PowerShell
# 2. 执行 set-ExecutionPolicy RemoteSigned 更改脚本执行策略
# 3. 配置脚本，执行 $profile 可以查看脚本路径
# 
# 

# 以管理员身份启动PowerShell
function admin { 
  start-process powershell -verb runAs 
}

function isAdmin { 
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function v2ray{
  D:\tools\v2ray\qv2ray-gui\qv2ray.exe
}

# build  aar for flutter project
function aar{
  $workDir = Get-Location
  # $buildNumber = git rev-list --count HEAD
  $buildNumber = $args
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

  # 直接在生成的目录下创建仓库，并关联远程，推送到远程
  # cd build\host\outputs\repo
  # git init 
  # git add -A
  # git commit -m $buildNumber
  # git remote add origin "https://github.com/yfbx-repo/maven.git"
  # git push -u -f origin master

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

function yxr{
  apk --feishu -f Yuxiaor $args
}

# print git log in formated style
function gitlog{
  git log --pretty=format:"%H - %ad, %an : %s" --date=iso
}

function cmt{
  git add -A
  git status
  git commit -m $args
}

# adb 命令查看任务栈
function ActivityStack{
  adb shell "dumpsys activity activities | sed -En -e '/Running activities/,/Run #0/p'"
}

# 打开取色器
function color{
  D:\tools\TakeColor.exe
}

# 打开Android Studio
function AS{
  D:\tools\Android\android-studio\bin\studio64.exe
}

# 打开QtScrcpy
function qt{
  D:\tools\QtScrcpy-win-x64-v1.6.0\QtScrcpy.exe
}

function startmogo{
  start D:\docs\company\mogo
}

function mogo{
  type D:\docs\company\mogo\mogo_account.txt
}

# 设置别名
Set-Alias astack ActivityStack

# 启动时清除微软广告
cls  
# 启动时打印字符画
type D:\tools\auto_pack\tag.txt

# 如果打开时当前路径是System32这个系统文件夹，切换到桌面
# $path = $pwd.path
# if ( $path.split("\")[-1] -eq "System32" ) {
#     $desktop = "C:\Users\" + $env:UserName + "\Desktop\"
#     cd $desktop
# }

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


chcp 65001
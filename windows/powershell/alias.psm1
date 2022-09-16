
# 重启终端
function reload(){
  pwsh
}

# 以管理员身份启动PowerShell
function admin { 
  start powershell -verb runAs 
}

function isAdmin { 
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 打开任务管理器
function tasks{
  C:\Windows\system32\taskmgr.exe /7
}


# 编辑系统环境变量
function env{
  start D:\Documents\EditSystemEnv
}

# 上帝模式 
function god{
  start "C:\Users\Administrator\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
}


# 打开 v2ray
function ssr{
  D:\tools\v2ray\qv2ray-gui\qv2ray.exe
}

# 打开取色器
function color{
  D:\tools\TakeColor.exe
}

# 打开Android Studio
function as{
  start D:\tools\Android\android-studio\bin\studio64.exe $args
}

# 打开QtScrcpy
function qt{
  D:\tools\QtScrcpy-win-x64-v1.6.0\QtScrcpy.exe
}

# 打印mogo账号信息
function mogo{
  cat D:\docs\company\mogo\mogo_account.txt
}

# print git log in formated style
function gitlog{
  git log --pretty=format:"%H - %ad, %an : %s" --date=iso
}

# add git tag
function gittag($tag){
  if($tag -eq $null){
    echo "tag content is required"
    return
  }
  git tag -a $tag -m $tag
}


# adb 命令查看任务栈
function adbstack{
  adb shell "dumpsys activity activities | sed -En -e '/Running activities/,/Run #0/p'"
}

# CPU 架构
function adbcpu{
  adb shell cat /proc/cpuinfo
}

# 查看 APK 信息
function apkinfo{
   aapt dump badging $args
}


# 查看APK签名信息
function apkcert{
   keytool -list -printcert -jarfile $args
}

# 查看 keystore 签名信息
function keystore($password,$file){
  if($password -eq $null){
    echo "请输入密钥库密码"
    return
  }
  if($file -eq $null){
    echo "请输入密钥库路径"
    return
  }
   keytool -list -v -storepass $password -keystore $file
}


# 查看网络信息
function wlan($name){
  if($name -eq $null){
    netsh wlan show profiles
  }else{
    netsh wlan show profile $name key=clear
  } 
}
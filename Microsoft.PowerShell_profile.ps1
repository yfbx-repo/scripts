# 
# PowerShell 启动时加载默认配置脚本
# 
# 1. 以管理员身份运行PowerShell
# 2. 执行 set-ExecutionPolicy RemoteSigned 更改脚本执行策略
# 3. 配置脚本，执行 $profile 可以查看脚本路径
# 

# 导入其他模块。必须使用绝对路径 
Import-Module D:\\Documents\\PowerShell\\pack.psm1
Import-Module D:\\Documents\\PowerShell\\shortcut.psm1

# 以管理员身份启动PowerShell
function admin { 
  start-process powershell -verb runAs 
}

function isAdmin { 
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
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

# 查看APK签名信息
function cert{
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

# 查看 APK 信息
function pkg{
   aapt dump badging $args
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


# 设置别名
Set-Alias astack ActivityStack


# 启动时清除微软广告
cls  
# 启动时打印字符画
cat D:\tools\auto_pack\tag.txt
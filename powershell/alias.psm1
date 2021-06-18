# ------------------ Git ------------------
# 
# print git log in formated style
function gitlog{
  git log --pretty=format:"%H - %ad, %an : %s" --date=iso
}


# ------------------ ADB ------------------
# adb 命令查看任务栈
function adbstack{
  adb shell "dumpsys activity activities | sed -En -e '/Running activities/,/Run #0/p'"
}

# CPU 架构
function adbcpu{
  adb shell cat /proc/cpuinfo
}

# ------------------ Tools ------------------
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
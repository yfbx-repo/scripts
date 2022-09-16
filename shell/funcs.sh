

# 
#  查看 keystore 信息
# 
function keystore_info(){
  if [ -z $1 ]; then
      echo "command: key-info <keystore>"
      return
  fi

  file=$1
  read -r -p "Password: " password
  
  if [ -f $file ];then
  
      keytool -list -v -storepass "$password" -keystore "$file" | grep "MD5" -A 3
  
      echo "注意：百度地图和高的地图等平台取的是MD5值"
  else 
      echo "$file is not found or invalid!"    
  fi
}

# 
# 生成 keystore 文件
# 
function keystore_gen(){
  read -r -p "请输入别名: " aliass
  read -r -p "请输入文件名: " fileName
  read -r -p "请输入密钥库口令: " password
  
  # 生成
  keytool -genkey -alias "$aliass" -keyalg RSA -validity 2000 -storepass "$password" -keystore "$fileName.keystore"
  # 转换
  keytool -importkeystore -srckeystore "$fileName.keystore" -destkeystore "$fileName.keystore" -deststoretype pkcs12
  # 查看信息
  keytool -list -v -keystore "$fileName.keystore" -storepass "$password"
}

# 
# 给APK签名
# 
function sign_apk(){
  read -r -p "待签名APK: " apk
  read -r -p "签名文件(keystore): " keystore
  read -r -p "签名文件别名: " aliass
  jarsigner -verbose -keystore "$keystore" -signedjar signed.apk "$apk" "$aliass"
}
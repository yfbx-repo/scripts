@echo off

echo/

set /p alias=请输入别名:
set /p fileName=请输入文件名:
set /p password=请输入密钥库口令:
keytool -genkey -alias %alias% -keyalg RSA -validity 2000 -storepass %password% -keystore %fileName%.keystore

keytool -importkeystore -srckeystore %fileName%.keystore -destkeystore %fileName%.keystore -deststoretype pkcs12

keytool -list -v -keystore %fileName%.keystore -storepass %password%

@cmd /k
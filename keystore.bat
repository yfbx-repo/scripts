@echo off

echo/

set /p alias=���������:
set /p fileName=�������ļ���:
set /p password=��������Կ�����:
keytool -genkey -alias %alias% -keyalg RSA -validity 2000 -storepass %password% -keystore %fileName%.keystore

keytool -importkeystore -srckeystore %fileName%.keystore -destkeystore %fileName%.keystore -deststoretype pkcs12

keytool -list -v -keystore %fileName%.keystore -storepass %password%

@cmd /k
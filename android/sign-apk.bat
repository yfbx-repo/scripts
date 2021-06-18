@echo off
echo.
echo ---------------自动签名脚本---------------
echo.
echo 用于给APK签名
echo.

set /p apk=待签名APK：
set /p keystore=签名文件(keystore)：
set /p alias=签名文件别名：

jarsigner -verbose -keystore %keystore% -signedjar signed.apk %apk% %alias%

@cmd /k
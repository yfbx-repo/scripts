@echo off
echo.
echo ---------------�Զ�ǩ���ű�---------------
echo.
echo ���ڸ�APKǩ��
echo.

set /p apk=��ǩ��APK��
set /p keystore=ǩ���ļ�(keystore)��
set /p alias=ǩ���ļ�������

jarsigner -verbose -keystore %keystore% -signedjar signed.apk %apk% %alias%

@cmd /k
@echo off

echo.
echo ----------kms服务器------------
echo    kms.03k.org
echo    kms.chinancce.com
echo    kms.lotro.cc
echo    kms.library.hk
echo ---------------------------------
echo 若无法激活，自行搜索kms服务器与密钥
echo.

set /p kms=kms服务器地址:
set /p key=请输入密钥:

call :activate %kms% %key%

:activate
slmgr /skms %1
slmgr /ipk %2
slmgr /ato
goto:eof

@cmd /k


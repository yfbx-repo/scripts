@echo off

echo.
echo ----------kms������------------
echo    kms.03k.org
echo    kms.chinancce.com
echo    kms.lotro.cc
echo    kms.library.hk
echo ---------------------------------
echo ���޷������������kms����������Կ
echo.

set /p kms=kms��������ַ:
set /p key=��������Կ:

call :activate %kms% %key%

:activate
slmgr /skms %1
slmgr /ipk %2
slmgr /ato
goto:eof

@cmd /k


@echo off 

goto menu


rem �˵�
:menu
echo.
echo 0.�˵�
echo 1.����ssh key
echo 2.����keystore
echo 3.svgתvector 
echo 4.�ֻ�����
echo 9.�˳�
echo.
goto choose

rem ѡ��
:choose
echo.
set /p id=��ѡ����ţ�
echo.
if %id%==0 goto  option0
if %id%==1 goto  option1
if %id%==2 goto  option2
if %id%==3 goto  option3
if %id%==4 goto  option4
if %id%==9 exit
echo.

:option0
goto menu

:option1
call ssh.bat

:option2
call keystore.bat

:option3
call svg/svg2vector.bat

:option4
call capture/capture.bat


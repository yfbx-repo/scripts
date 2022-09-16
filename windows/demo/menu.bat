@echo off 

goto menu


rem 菜单
:menu
echo.
echo 0.菜单
echo 1.生成ssh key
echo 2.生成keystore
echo 3.svg转vector 
echo 4.手机截屏
echo 9.退出
echo.
goto choose

rem 选择
:choose
echo.
set /p id=请选择序号：
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


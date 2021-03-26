@echo off

rem 初始化参数
set flavor=Yuxiaor
set type=Debug
call:loopParams

git pull
call %~dp0clean.bat
call %~dp0build.bat %type% %flavor%


set file_dir=app/build/outputs/apk/%flavor%/%type%
for /R %file_dir% %%f in (*.apk) do set apk=%%f

post_apk %apk%

@cmd /k

rem 遍历传入参数
:loopParams
if "%1"=="" goto:eof
if "%1"=="-f" set flavor=%2
SHIFT&SHIFT
if "%1"=="" goto:eof else goto:loop

:setType
if "%1"=="release" set type=Release else set type=Debug
SHIFT
goto:loop


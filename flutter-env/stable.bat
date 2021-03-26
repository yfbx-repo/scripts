@echo off


@cd/d"%~dp0"&(cacls "%SystemDrive%\System Volume Information" >nul 2>nul)||(start "" mshta vbscript:CreateObject^("Shell.Application"^).ShellExecute^("%~nx0"," %*","","runas",1^)^(window.close^)&exit /b)

setx /m "FLUTTER_HOME" "D:\tools\flutter-stable\bin"

refreshenv

set FLUTTER_HOME

flutter --version

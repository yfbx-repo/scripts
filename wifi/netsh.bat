@echo off 

netsh wlan show profiles
netsh wlan show profile %wifi% key=clear > %~dp0all.txt
goto wifiPwd

:wifiPwd
set /p wifi=WIFI:
netsh wlan show profile %wifi% key=clear
netsh wlan show profile %wifi% key=clear > %~dp0%wifi%.txt
echo.
echo.
goto wifiPwd



@echo off
doskey ubuntu=call StartXUbuntu.bat
doskey aar=flutter build aar --no-release --no-profile --build-number $*
doskey ActivityStack=adb shell "dumpsys activity activities | sed -En -e '/Running activities/,/Run #0/p'"
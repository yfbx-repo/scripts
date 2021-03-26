@echo off

set apkPath=%1
call:getFileName %apkPath%

copy %apkPath% %web%\%type% /y
set url=%host%/apk/%apk%

echo "<head><script>window.location.href = "%url%";</script></head>" > %web%\index.html

set markdown="![](%qrcode%)  \n  APK:[%apk%](%url%)"
post %token% %markdown%

:getFileName
set name=%~n1
set suffix=%~x1
set apk=%name%%suffix%

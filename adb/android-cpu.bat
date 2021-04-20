@echo off

echo.
echo CPU¼Ü¹¹
adb shell getprop ro.product.cpu.abi
echo.
echo.
adb shell cat /proc/cpuinfo

@cmd /k
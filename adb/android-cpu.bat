@echo off

echo.
echo CPU�ܹ�
adb shell getprop ro.product.cpu.abi
echo.
echo.
adb shell cat /proc/cpuinfo

@cmd /k
@echo off
C:
cd C:\Users\Administrator\.ssh

echo/
set /p email=请输入邮箱地址:
echo/

ssh-keygen -t rsa -C %email%
ssh-add id_rsa
clip < id_rsa.pub

echo/
echo 公钥已经复制到剪切板，可直接配置到git平台
echo/
echo 配置完成后执行 ssh -vT git@yuxiaor.com 命令查看配置结果
echo/
echo/
@cmd /k
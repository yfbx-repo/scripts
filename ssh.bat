@echo off
C:
cd C:\Users\Administrator\.ssh

echo/
set /p email=�����������ַ:
echo/

ssh-keygen -t rsa -C %email%
ssh-add id_rsa
clip < id_rsa.pub

echo/
echo ��Կ�Ѿ����Ƶ����а壬��ֱ�����õ�gitƽ̨
echo/
echo ������ɺ�ִ�� ssh -vT git@yuxiaor.com ����鿴���ý��
echo/
echo/
@cmd /k
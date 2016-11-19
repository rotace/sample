@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\align_imgsize.ps1 %*
cd
pause
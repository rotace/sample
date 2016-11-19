@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\clear_background.ps1 %*
cd
pause
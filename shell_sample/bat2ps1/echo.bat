@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\echo.ps1 %*
cd
pause
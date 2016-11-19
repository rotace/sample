@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\hello.ps1
cd
pause
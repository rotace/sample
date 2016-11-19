@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\svg2eps.ps1 %*
cd
pause
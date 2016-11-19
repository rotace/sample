@echo off
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Unrestricted .\svg2emf.ps1 %*
cd
pause
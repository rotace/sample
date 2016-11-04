@echo off
cd /d %~dp0
"C:\cygwin\bin\bash.exe" --login -i -c "/home/user/hello.sh %*"
cd
pause

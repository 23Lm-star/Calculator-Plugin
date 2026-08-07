@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-Calculator.ps1"
exit /b %ERRORLEVEL%

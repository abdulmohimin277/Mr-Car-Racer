@echo off
setlocal
title Mr-Racer Installer
cd /d "%~dp0"
echo.
echo  Creating the Mr-Racer desktop shortcut...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-Mr-Racer.ps1" -NoLaunch
if errorlevel 1 (
  echo.
  echo  Could not create the shortcut. Right-click this file and choose "Run as administrator".
  echo.
  pause
  exit /b 1
)
echo.
echo  Done! The Mr-Racer shortcut is on your Desktop and in the Start Menu.
echo  Double-click the Mr-Racer icon to play.
echo.
pause

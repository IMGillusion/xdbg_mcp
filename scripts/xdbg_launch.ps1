# launch x64dbg in interactive console session (elevated)
$principal = New-ScheduledTaskPrincipal -UserId 'Administrator' -LogonType S4U -RunLevel Highest
$action = New-ScheduledTaskAction -Execute 'C:\x64dbg\release\x64\x64dbg.exe' -WorkingDirectory 'C:\x64dbg\release\x64'
Register-ScheduledTask -TaskName XdbgMcp -Action $action -Principal $principal -Force | Out-Null
Start-ScheduledTask -TaskName XdbgMcp
Start-Sleep -Seconds 12
Write-Output ('x64dbg_proc=' + [bool](Get-Process x64dbg -ErrorAction SilentlyContinue))
Write-Output ('port9094=' + [bool](netstat -ano | Select-String ':9094'))

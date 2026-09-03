# start notepad in console session via scheduled task (GUI needs desktop)
$p = New-ScheduledTaskPrincipal -UserId 'Administrator' -LogonType S4U -RunLevel Highest
$a = New-ScheduledTaskAction -Execute 'notepad.exe'
Register-ScheduledTask -TaskName NotepadTest -Action $a -Principal $p -Force | Out-Null
Start-ScheduledTask -TaskName NotepadTest
Start-Sleep -Seconds 3
$np = Get-Process notepad -ErrorAction SilentlyContinue | Select-Object -First 1
if ($np) { Write-Output ('NOTEPAD_PID=' + $np.Id) } else { Write-Output 'NOTEPAD_PID=0' }

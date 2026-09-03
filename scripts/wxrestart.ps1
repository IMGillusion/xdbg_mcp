# restart Weixin in console session (after debugger kill)
$p = New-ScheduledTaskPrincipal -UserId 'Administrator' -LogonType S4U -RunLevel Highest
$a = New-ScheduledTaskAction -Execute 'C:\Program Files\Tencent\Weixin\Weixin.exe'
Register-ScheduledTask -TaskName WeixinRestart -Action $a -Principal $p -Force | Out-Null
Start-ScheduledTask -TaskName WeixinRestart
Start-Sleep -Seconds 20
Get-Process Weixin -ErrorAction SilentlyContinue | Select-Object Id, ProcessName | Format-Table -AutoSize
Write-Output ('port30001=' + [bool](netstat -ano | Select-String ':30001.*LISTENING'))
try {
    $s = Invoke-RestMethod -Uri 'http://127.0.0.1:30001/QueryDB/status' -TimeoutSec 5
    Write-Output ('querydb=' + ($s | ConvertTo-Json -Compress))
} catch {
    Write-Output ('querydb=FAIL ' + $_.Exception.Message)
}

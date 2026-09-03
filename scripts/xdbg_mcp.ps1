# xdbg_mcp.ps1 - call x64dbg MCP server
# usage: powershell -File xdbg_mcp.ps1 <ToolName|LIST> [key=value ...]
# values: if numeric stays unquoted, else quoted as JSON string
param(
    [Parameter(Position=0)][string]$Tool,
    [Parameter(Position=1, ValueFromRemainingArguments)][string[]]$Kv
)
$tok = (Get-Content 'C:\x64dbg\release\x64\mcp_config.json' -Raw | ConvertFrom-Json).AuthToken
$headers = @{ Authorization = 'Bearer ' + $tok; Accept = 'application/json, text/event-stream' }
$uri = 'http://127.0.0.1:9094/'

$init = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"qbot","version":"1.0"}}}'
$initResp = Invoke-WebRequest -Uri $uri -Method Post -Body $init -ContentType 'application/json' -Headers $headers
$session = $initResp.Headers['Mcp-Session-Id']
if ($session) { $headers['Mcp-Session-Id'] = $session }

if ($Tool -eq 'LIST') {
    $body = '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
} else {
    $parts = @()
    foreach ($item in $Kv) {
        $idx = $item.IndexOf('=')
        $k = $item.Substring(0, $idx)
        $v = $item.Substring($idx + 1)
        if ($v -match '^-?\d+$') { $parts += ('"' + $k + '":' + $v) }
        else { $parts += ('"' + $k + '":"' + $v + '"') }
    }
    $argsJson = '{' + ($parts -join ',') + '}'
    $body = '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"' + $Tool + '","arguments":' + $argsJson + '}}'
}
$resp = Invoke-WebRequest -Uri $uri -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$text = $resp.Content
if ($text -match 'data:\s*(\{.*\})') { $text = $Matches[1] }
$text | Out-String | Write-Output

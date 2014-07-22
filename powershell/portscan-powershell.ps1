#########################################################
# 
# portscan-powershell.ps1 version 0.2
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

<#
    .SYNOPSIS
      A simple port scanner implemented in PowerShell.
    .EXAMPLE
	C:\PS> .\portscan-powershell.ps1 [target]
    .EXAMPLE
	C:\PS> .\portscan-powershell.ps1 attackdebris.com
#>

[cmdletbinding()]
param (
	[switch]$h,
	[switch]$help,
	[Parameter(Mandatory=$False)]
	[string[]]$p,
	[Parameter(Position=0,Mandatory=$False)]
	[string]$target
)

if ($target -eq "" -Or $target -eq "-h" -Or $target -eq "--h" -Or $target -eq "-help" -Or $target -eq "--help")
{
echo "portscan-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage (common ports):"
echo "  .\portscan-powershell.ps1 [target]"
echo "  e.g. .\portscan-powershell.ps1 attackdebris.com"
echo "PORT SPECIFICATION (optional):"
echo "  -p <port ranges>: Only scan specified ports"
echo "  e.g. -p 20-22 [target]"
echo "  e.g. -p 20,21,22 [target]"
exit
}

if ($p.count -lt 1)
{
$p = 21,22,23,25,53,80,135,139,443,445,1433,1521,3306,3389
}

if ($p -match "-")
{
$p = $p -split "-"
$lp = $p[0]
$hp = $p[1]
$p = ""
$p = $lp..$hp
}

if ($target -ne "")
{
$date = Get-Date -format "yyyy-MM-dd HH:MM" 

echo "Starting portscan-powershell.ps1 ( https://github.com/attackdebris/babel-sf ) at $date"
$ip = [System.Net.Dns]::GetHostAddresses($target)
if ($target -eq $ip) {
echo "Scan report for $target"
}
else {
echo "Scan report for $target ($ip)"
}
echo "PORT   STATE"

foreach ($i in $p) {
try {
$Test = new-object System.Net.Sockets.TCPClient
$status = ( $Test.BeginConnect( $target, $i,  $Null, $Null ) ).AsyncWaitHandle.WaitOne( 400 )
} catch {}
#echo "$status"
if ($status -eq 'True') {
echo "$i/tcp open"
}
}
echo "`nportscan-powershell.ps1 scan done"
}
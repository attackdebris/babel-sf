#########################################################
# 
# arpscan-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

param (
	[Parameter()]
	[string]$http_resource,
	[switch]$h,
	[switch]$help
)

if ($args -ne "")
{
echo "arpscan-powershell.ps1 ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\arpscan-powershell.ps1"
exit
}

echo "arpscan-powershell.ps1 ( https://github.com/attackdebris/babel-sf )" 

# Yeah, its not that smart it simply treats the subnet as a class c subnet
$full_ip = (Get-WmiObject -class win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"').Syncroot[0].IPaddress.Syncroot[0]
$ip_byte = $full_ip.Split(".")
$subnet_ip = ($ip_byte[0]+"."+$ip_byte[1]+"."+$ip_byte[2]+".") 

# Quick and dirty port scan to populate the ARP tables
$octet=1..254
$port=53
foreach ($i in $octet) {
$target = $subnet_ip+$i
$Test = new-object System.Net.Sockets.TCPClient
$status = ( $Test.BeginConnect( $target, $port,  $Null, $Null ) )
}
Start-Sleep -s 3

$macarray = @()
(arp -a) -match "dynamic" | Foreach{
	$obj = New-Object PSObject -Property @{
		"IP Address" = ($_ -split "\s+")[1]
        "MAC Address" = ($_ -split "\s+")[2]
    }
    $macarray += $obj
    }
echo "`nActive Network Hosts:"
Write-Output $macarray | Select "IP Address","MAC Address" | ft -autosize
echo "arpscan-powershell.ps1 scan done" 
#########################################################
# 
# portscan-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

param ( [string]$target)

$date = Get-Date -format "yyyy-MM-dd HH:MM"

# A list of ports separated by commas eg. 21,22,23,25,80,443
# A range of ports, eg. 1..10
#$range = 1..1024
$range = 21, 22, 23, 25, 53, 80, 135, 139, 443, 445, 1433, 3306, 3389

echo "Starting portscan-powershell.ps1 ( https://github.com/attackdebris/babel-sf ) at $date"
echo "Scan report for $target"
echo "PORT   STATE"

foreach ($i in $range) {
try {
$Test = new-object System.Net.Sockets.TCPClient
$status = ( $Test.BeginConnect( $target, $i,  $Null, $Null ) ).AsyncWaitHandle.WaitOne( 250 )
} catch {}
#echo "$status"
if ($status -eq 'True') {
echo "$i/tcp open"
}
}
echo ""
echo "portscan-powershell.ps1 scan done"
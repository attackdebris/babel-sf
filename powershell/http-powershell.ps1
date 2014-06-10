#########################################################
#
# http-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

param (
[Parameter()]
[string]$port_number,
[switch]$h,
[switch]$help
)

if ($port_number -eq "" -Or $port_number -eq "-h" -Or $port_number -eq "--h" -Or $port_number -eq "-help" -Or $port_number -eq "--help")
{
echo "http-powershell.ps1 ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\http-powershell.ps1 [port number]"
echo "e.g. .\http-powershell.ps1 80`n"
echo "[Note: Must be run in an admin context e.g. right click command prompt > 'runas administrator']`n"
exit
}

$routes = @{
"/" = {return "<html><body><b>http-powershell.ps1 (version 0.1) - babel-sf</b>  ( https://github.com/attackdebris/babel-sf )<br /><br /><br /><b>Local directory</b> = $path<br /><br /><b>Read File:</b> Append filename listed below to the URL e.g. http://192.168.0.1/[my_filename]<br /><br /><b>Download File:</b> Files can be downloaded via 'wget' e.g. wget http://192.168.0.1/[my_filename]<br /><br /><b>File Listing:</b> <br />$files</html>" }
}

$url = "http://+:$port_number/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()
$route = $null

Write-Host "Starting http-powershell.ps1 ( https://github.com/attackdebris/babel-sf )`n"
Write-Host "Listening on port $port_number..."

while ($listener.IsListening)
{
	$context = $listener.GetContext()
	$requestUrl = $context.Request.Url
	$localPath = $requestUrl.LocalPath
	$route = $routes.Get_Item($requestUrl.LocalPath)
	$response = $context.Response
	
	$path = Get-Location
	$dir = Get-ChildItem | where-object {$_.Attributes -ne "Directory"} 
	$files = $dir -split "`r`n" | Foreach-Object{ $_ + '<br />' }

 	Write-Host ''	
	Write-Host "> $requestUrl"

	if ($route -eq $null) #serve child-items
	{
	$response.Headers.Add("Content-Type","text/plain")
	$buffer = [Text.Encoding]::UTF8.GetBytes((GC (Join-Path $Pwd ($context.Request).RawUrl)))
	$response.ContentLength64 = $buffer.Length
	$response.OutputStream.Write($buffer,0,$buffer.Length)
	$response.Close()
	}
	else #serve main
	{
	$content = & $route
	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
	$response.ContentLength64 = $buffer.Length
	$response.OutputStream.Write($buffer, 0, $buffer.Length)
	}
	$response.Close()
	
	$responseStatus = $response.StatusCode
	Write-Host "< $responseStatus"
}
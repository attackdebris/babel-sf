#########################################################
# 
# wget-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

param (
[Parameter()]
[string]$http_resource,
[string]$local_file
)

if ($http_resource -eq "")
{
echo "wget-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\wget-powershell.ps1 [http(s) server resource] [local filename]"
echo "e.g. .\wget-powershell.ps1 https://github.com/attackdebris/babel-sf/archive/master.zip master.zip`n"
exit
}
echo "Starting wget-powershell.ps1 ( https://github.com/attackdebris/babel-sf )`n"
echo "Attempting to download the following resource: $http_resource`n"
(new-object System.Net.WebClient).Downloadfile("$http_resource", "$local_file")
echo "Complete, resource saved as $local_file"
#########################################################
# 
# wget-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

param (
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$http_resource,
	[string]$local_file,
	[switch]$h,
	[switch]$help
)

if ($http_resource -eq "" -Or $http_resource -eq "-h" -Or $http_resource -eq "--h" -Or $http_resource -eq "-help" -Or $http_resource -eq "--help" ){
echo "wget-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\wget-powershell.ps1 [http(s) server resource] [local filename]"
echo "e.g. .\wget-powershell.ps1 https://github.com/attackdebris/babel-sf/archive/master.zip master.zip`n"
Exit
}
elseif  ($local_file -eq "") {
echo "wget-powershell.ps1 ( https://github.com/attackdebris/babel-sf )"
echo "`nError, 2 arguments are required, a remote filename and a local filename, check your syntax`n"
Exit
}
elseif  ($local_file -ne "") {
echo "Starting wget-powershell.ps1 ( https://github.com/attackdebris/babel-sf )`n"
echo "Attempting to download the following resource: $http_resource`n"
(new-object System.Net.WebClient).Downloadfile("$http_resource", "$local_file")
echo "Complete, resource saved as $local_file"
}
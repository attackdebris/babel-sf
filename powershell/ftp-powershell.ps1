#########################################################
# 
# ftp-powershell.ps1 version 0.1
#
# babel-sf ( https://github.com/attackdebris/babel-sf )
#
#########################################################

<#
    .SYNOPSIS
      A simple ftp client implemented in PowerShell.
	
	.EXAMPLE
	C:\PS> ./ftp-powershell.ps1 [FTP Server IP] ls - List contents of FTP Server
	
	.EXAMPLE
	C:\PS> ./ftp-powershell.ps1 [FTP Server IP] get [remote filename] - Download file from FTP Server
	
	.EXAMPLE
	C:\PS> ./ftp-powershell.ps1 [FTP Server IP] put [local filename] - Upload file to FTP Server
#>

param (
	[Parameter()]
	[string]$target,
	[string]$function,
	[string]$filename
)

if ($function -eq "")
{
echo "ftp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\ftp-powershell.ps1 [FTP Server IP] ls - List contents of FTP Server"
echo ".\ftp-powershell.ps1 [FTP Server IP] get [remote filename] - Download file from FTP Server"
echo ".\ftp-powershell.ps1 [FTP Server IP] put [local filename] - Upload file to FTP Server`n"
#echo "FTP Server IP: $target, Function: $function, Filename: $filename"
}

elseif (($function -eq "get" -or $function -eq "put" -and $filename -eq ""))
{
echo "ftp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )"
echo "`nUsage:"
echo ".\ftp-powershell.ps1 [FTP Server IP] ls - List contents of FTP Server"
echo ".\ftp-powershell.ps1 [FTP Server IP] get [remote filename] - Download file from FTP Server"
echo ".\ftp-powershell.ps1 [FTP Server IP] put [local filename] - Upload file to FTP Server`n"
#echo "FTP Server IP: $target, Function: $function, Filename: $filename"
}

elseif ($function -eq "ls")
{
# FTP dir
echo "ftp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )`n"
$username = Read-Host 'Username'
$password = Read-Host -assecurestring 'Password'
echo "`nroot directory file listing:"
$ftp = [System.Net.WebRequest]::Create("ftp://$target") 
$ftp.Method = [System.Net.WebRequestMethods+FTP]::ListDirectoryDetails
$ftp.Credentials = new-object System.Net.NetworkCredential("$username","password")

$response = $ftp.getresponse() 
$stream = $response.getresponsestream() 

$buffer = new-object System.Byte[] 1024 
$encoding = new-object System.Text.AsciiEncoding 

$outputBuffer = "" 
$foundMore = $false 

do 
{ 
    start-sleep -m 10

    $foundmore = $false 
    $stream.ReadTimeout = 10

    do 
    { 
        try 
        { 
            $read = $stream.Read($buffer, 0, 1024) 

            if($read -gt 0) 
            { 
                $foundmore = $true 
                $outputBuffer += ($encoding.GetString($buffer, 0, $read)) 
            } 
        } catch { $foundMore = $false; $read = 0 } 
    } while($read -gt 0) 
} while($foundmore)

$outputBuffer
}

elseif ($function -eq "put")
{
# FTP Upload
echo "ftp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )`n"
$username = Read-Host 'Username'
$password = Read-Host -assecurestring 'Password'
$ftp = [System.Net.FtpWebRequest]::Create("ftp://$target/$filename")
$ftp = [System.Net.FtpWebRequest]$ftp
$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftp.Credentials = new-object System.Net.NetworkCredential("$username","$password")
$ftp.UseBinary = $true
$ftp.UsePassive = $true
# read in file to upload
$content = [System.IO.File]::ReadAllBytes("$filename")
$ftp.ContentLength = $content.Length
# get request stream, write into it
$rs = $ftp.GetRequestStream()
$rs.Write($content, 0, $content.Length)
# clearn up
$rs.Close()
$rs.Dispose()
if (test-path $filename)
{
echo "`nSuccessfully uploaded: $filename"
}
elseif (!(test-path $filename))
{
echo "`nError, $filename does not exist"
}
}

elseif ($function -eq "get")
{
# FTP download
echo "ftp-powershell.ps1 - ( https://github.com/attackdebris/babel-sf )`n"
$username = Read-Host 'Username'
$password = Read-Host -assecurestring 'Password'
$FTPRequest = [System.Net.FtpWebRequest]::Create("ftp://$target/$filename")
$FTPRequest.Credentials = new-object System.Net.NetworkCredential("$username","$password")
$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
$FTPRequest.UseBinary = $true
$FTPRequest.UsePassive = $true
$FTPRequest.KeepAlive = $false

# Get FTP File
$FTPResponse = $FTPRequest.GetResponse() 
$ResponseStream = $FTPResponse.GetResponseStream()
# create the target file on the local system  
$LocalFile = New-Object IO.FileStream ($filename,[IO.FileMode]::Create)  
[byte[]]$readbuffer = New-Object byte[] 1024  
 
# download stream and send to target file  
Try
{
do{  
    $readlength = $ResponseStream.Read($readbuffer,0,1024)  
    $LocalFile.Write($readbuffer,0,$readlength)  
}  
while ($readlength -ne 0)  
}
Catch
{
echo "Error, check your filename and/or credentials!"
exit
}

echo "`nSuccessfully downloaded: $filename" 
$LocalFile.close()
}


# More info: https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

# Remote to server
Enter-PSSession WAC01 -Credential $cred

# Demonstrate OS Level
Get-ComputerInfo -Property OSServerLevel

# Download WAC
$dlPath = 'C:\Users\Administrator\Downloads\WAC.msi'
Invoke-WebRequest 'http://aka.ms/WACDownload' -OutFile $dlPath

# Install
$port = 443
msiexec /i $dlPath /qn /L*v log.txt SME_PORT=$port SSL_CERTIFICATE_OPTION=generate

While($true){
    Write-Host 'Waiting for reboot'
    Start-Sleep -Seconds 2
}

# If you already had a certificate
$port = 443
msiexec /i $dlPath /qn /L*v log.txt SME_PORT=$port SME_THUMBPRINT=$CertThumprint SSL_CERTIFICATE_OPTION=installed
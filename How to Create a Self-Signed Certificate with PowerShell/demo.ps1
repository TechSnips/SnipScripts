$cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname testcert.techsnips.io
$cert

$secPassword = ConvertTo-SecureString -String 'passw0rd!' -Force -AsPlainText

$certPath = "Cert:\localMachine\my\$($cert.Thumbprint)"
Export-PfxCertificate -Cert $certPath -FilePath c:\selfcert.pfx -Password $secPassword

## We can now import this using the password
Import-PfxCertificate -Password $secPassword -FilePath C:\selfcert.pfx -CertStoreLocation 'Cert:\CurrentUser\My'
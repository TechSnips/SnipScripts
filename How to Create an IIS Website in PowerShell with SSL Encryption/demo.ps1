#region Creating the IIS site and SSL binding
## Create the new website
New-Website -Name DemoSite -PhysicalPath C:\inetpub\wwwroot\

## Notice all web bindings created
Get-WebBinding

## Find the bindings only on the website we just created
(Get-Website -Name 'DemoSite').bindings.Collection

## Add a new binding to the site bound to all IP adddress for our SSL connection
New-WebBinding -Name 'DemoSite' -IPAddress * -Port 443 -Protocol https

## Notice the bindings now
(Get-Website -Name 'DemoSite').bindings.Collection
#endregion

#region Installing a certificate

## Create a self-signed certificate assigning it to a variable to use in the next step
$cert = New-SelfSignedCertificate -CertStoreLocation 'Cert:\LocalMachine\My' -DnsName 'demosite.demo.local'

## Attach the certificate to the SSL binding
$certPath = "Cert:\LocalMachine\My\$($cert.Thumbprint)"
$providerPath = 'IIS:\SSLBindings\0.0.0.0!443' ## Binding to all IP addresses and to port 443
Get-Item $certPath | New-Item $providerPath

## View the bound certificate's DNS name in the IIS snapin
## Internet Information Services Manager --> Sites --> DemoSite --> Bindings --> Click on HTTPS binding --> Edit

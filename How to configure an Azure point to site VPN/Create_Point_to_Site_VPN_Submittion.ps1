
#Create a self-signed root certificate

$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
 -Subject "CN=TechSnipsCertRoot" `
  -KeyExportPolicy Exportable `
   -HashAlgorithm sha256 `
    -KeyLength 2048 `
     -CertStoreLocation "Cert:\CurrentUser\My" `
      -KeyUsageProperty Sign `
       -KeyUsage CertSign

#Generate a client certificate

New-SelfSignedCertificate -Type custom `
 -DnsName TechSnips-ClientCert`
  -KeySpec Signature`
   -Subject "CN=TechSnipsCertClient" `
    -KeyExportPolicy Exportable `
     -HashAlgorithm sha256 `
      -KeyLength 2048 `
       -CertStoreLocation "Cert:\CurrentUser\My" `
        -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
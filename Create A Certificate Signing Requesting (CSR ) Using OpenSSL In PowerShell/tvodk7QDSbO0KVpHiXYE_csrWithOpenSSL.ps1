$certDir = 'C:\certs'
$certCommonName = 'testcert.techsnips.io' # Should match the hostname used when connected with SSL

#region Create Private Key
# If you don't already have a directory to organize your certificates, create one
# new-item -ItemType Directory -Path $certDir
set-location $certDir

$privateKeyName = $certCommonName + '.key'
$privateKeyName

$genRsaArgs = "genrsa -out $privateKeyName 2048"
Start-Process openssl $genRsaArgs

ise $privateKeyName
#endregion Create Private Key

#region Set SSL settings

# Download Sample OpenSSL config file if you don't have a default configured
Invoke-WebRequest 'http://web.mit.edu/crypto/openssl.cnf' -OutFile openssl.cnf

$country = 'US' #2 character country code, see Wikipidea if unsure
$state = 'Michigan' # State or Province
$locality = 'Detroit'
$org = 'TechSnips' # Orginization Name
$ou = 'Sniping and Recieving' # Orginization Unit Name (Finance, Human Resources, etc..)
$cn = $certCommonName # Common Name
$email = 'help@techsnips.io'
#endregion Set SSL settings

#region Generate CSR
$csrName = $certCommonName + '.csr'

$subject = "`"/C=$country/ST=$state/L=$locality/O=$org/OU=$ou/CN=$cn`""
$openSSlArgs = "req -new -key $privateKeyName -out $csrName -config openssl.cnf -subj $subject"
Start-Process openssl $openSSlArgs

ise $csrName

# validate
openssl req -in $csrName -noout -text -config openssl.cnf | out-file csrInfo.txt 
ise .\csrInfo.txt
rm .\csrInfo.txt
#endregion Generate CSR
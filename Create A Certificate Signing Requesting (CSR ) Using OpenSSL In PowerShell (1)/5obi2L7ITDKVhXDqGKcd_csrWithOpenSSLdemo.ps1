function new-csr {
[cmdletbinding()]
param(
    $country, #2 character country code, see Wikipedia if unsure
    $state, # State or Province
    $locality, # City, Township, etc.
    $org, # Organization Name
    $ou, # Organization Unit Name (Finance, Human Resources, etc..)
    $cn, # Common Name, Should match the hostname used when connected with SSL
    $email, # Contact Email Address
    $randPath, # path to Random file
    $privateKeyPath, # Path to private key
    $csrPath # Path to Certificate Signing Request (output)
)
    # If a private key has not been created, create one
    if (-not (Test-Path $privateKeyPath)){
        openssl genrsa -out $privateKeyPath 2048
    }
   
    if (-not (Test-Path $randPath)){
        openssl rand -out $randPath # Uses hardware such as Intel's RDRAND to create seed for randomness
    }

    $subject = "`"/C=$country/ST=$state/L=$locality/O=$org/OU=$ou/CN=$cn`""
    
    openssl req -new -key $privateKeyPath -rand $randPath -subj $subject -out $csrPath
    # If you get an error here, like 'no conf or environment variable' you need an OpenSSL Config file or
    # to set the OPENSSL_CONF environment variable, see my getting started with OpenSSL snip.
}
$newCsrArgs = @{
    country = 'US'
    state = 'Michigan'
    locality = 'Detroit'
    org = 'TechSnips'
    ou = 'Tech Snipping and Recieving'
    cn = 'testcert.techsnips.io'
    email = 'support@techsnips.io'
    randPath = 'C:\certs\.rnd'
    privateKeyPath = 'C:\certs\testcert.techsnips.io.key'
    csrPath = 'C:\certs\testcert.techsnips.io.csr'
}

new-csr @newCsrArgs

# Validate CSR
code $csrPath
openssl req -in $csrPath -noout -text | code -
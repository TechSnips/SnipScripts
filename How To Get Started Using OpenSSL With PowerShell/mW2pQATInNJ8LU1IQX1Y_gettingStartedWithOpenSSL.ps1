#region Install OpenSSL 

# Install Chocolatey if needed, for issues see https://chocolatey.org/install
## Alternatively install from http://gnuwin32.sourceforge.net/packages/openssl.htm
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (
    (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
)
choco -?

choco install OpenSSL.Light -y
#endregion Install OpenSSL

#region customize your environment 

### Create a PowerShell profile if you don't have one already
### Your profile script runs everytime you launch PowerShell and is customizable.

# Create a directory dedicated to managing certificates
New-Item -ItemType Directory -Path C:\certs

# Download example config file
Invoke-WebRequest 'http://web.mit.edu/crypto/openssl.cnf' -OutFile C:\certs\openssl.cnf

# Edit config file as desired, see https://www.openssl.org/docs/manmaster/man5/config.html
# Change / to \ in the CA_default section if performing Certificate Authority tasks
ise C:\certs\openssl.cnf

if (-not (test-path $profile)){
    New-Item –Path $Profile –Type File –Force
}
'$env:path = "$env:path;C:\Program Files\OpenSSL\bin"' | out-file $profile -Append
'$env:OPENSSL_CONF = "C:\certs\openssl.cnf"' | out-file $profile -Append

ise $profile

# re-open your PowerShell terminal or manually run your profile script
. $profile

$env:path
$env:OPENSSL_CONF
#endregion customize your environment 

#region Running OpenSSL
#confirm OpenSSL works
openssl version

# interactive commands are not supported in ISE, use Ctrl+C to escape
OpenSSL req -new -out first.csr

$openSSlArgs = "req -new -out first.csr"
Start-Process openssl $openSSlArgs
#endregion Runnincdg OpenSSL
##########################################################################
#                                                                        #
# Install Win32 OpenSSH                                                  #
# https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH #
#                                                                        #
# This script available at: https://github.com/TechSnips/SnipScripts     #
#                                                                        #
##########################################################################

$installPath = 'C:\Program Files\OpenSSH\'
$zipFile = "$env:USERPROFILE\downloads\OpenSSH-Win64.zip"

# Unzip archive to Installation Path
Expand-Archive -Path $zipFile -DestinationPath $installPath -Force

# Run the SSH install script
& "$installPath\OpenSSH-Win64\install-sshd.ps1"

# Add SSH exception to the firewall (port 22)
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Get SSH services
get-service *ssh*

# Set SSH services to Automatic
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic

# Start SSH services
Start-Service sshd
Start-Service ssh-agent

# Run netstat to verify listening on port 22
netstat -bano | Select-String -Pattern ':22'


# Set default shell to PowerShell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force


# Uninstall SSH Services
& "$installPath\OpenSSH-Win64\uninstall-sshd.ps1"
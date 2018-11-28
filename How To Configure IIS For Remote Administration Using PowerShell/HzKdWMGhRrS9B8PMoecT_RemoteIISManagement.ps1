
$server = ''

Enter-PSSession $server

# See if the Web Management feature is installed
Get-WindowsFeature Web-Mgmt-Service

# Add Web Management Feature
Add-WindowsFeature Web-Mgmt-Service

# Get the current value of EnableRemoteManagement
Get-ItemProperty -Path 'HKLM:\Software\Microsoft\WebManagement\Server' -Name EnableRemoteManagement

# Change EnableRemoteManagement value to 1 to allow remote connections
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\WebManagement\Server' -Name EnableRemoteManagement -Value 1

# Get the Web Management Service Firewall rule
Get-NetFirewallRule IIS-WebServerRole-WMSVC-In-TCP

# New-NetFirewallRule -DisplayName "Web Management Service" -Direction Inbound -LocalPort 8172 -Protocol TCP -Action Allow

# Get the Web Management Service status
Get-Service WMSVC

# Start the Web Management Service
Start-Service WMSVC

# Set the WMSVC service to start automatically
Set-Service WMSVC -StartupType Automatic


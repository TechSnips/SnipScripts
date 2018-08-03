#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

<#
    Set static IP via PowerShell
    https://www.techsnips.io/en/playing/how-to-set-an-ip-address-to-static-and-dhcp-with-powershell/stream/0
#>

#region install DHCP

#Find the DHCP server name
Get-WindowsFeature | Where-Object Name -like "*DHCP*"

#Install it with the management tools
Install-WindowsFeature DHCP -IncludeManagementTools

#endregion

#region Post install tasks

#Create security groups

#Current Groups 
($([ADSI]"WinNT://$env:COMPUTERNAME").Children | Where-Object SchemaClassName -eq 'group').name

#Use netsh to create new ones
netsh dhcp add securitygroups

#Verify group creation
($([ADSI]"WinNT://$env:COMPUTERNAME").Children | Where-Object SchemaClassName -eq 'group').name

#Restart the DHCP server service
Restart-Service dhcpserver

#endregion

#region Authorize in AD

#Check current DHCP servers
Get-DhcpServerInDC

#Get IP
Get-NetIPAddress -InterfaceAlias Ethernet -AddressFamily IPv4
$LocalIP = (Get-NetIPAddress -InterfaceAlias Ethernet -AddressFamily IPv4).IPAddress

#Get fully qualified computer name
Resolve-DnsName $env:COMPUTERNAME
$LocalFQDN = (Resolve-DnsName $env:COMPUTERNAME | Where-Object Type -eq 'A').Name

#Authorize the server
Add-DhcpServerInDC -DnsName $LocalFQDN -IPAddress $LocalIP

#Verify
Get-DhcpServerInDC

#endregion
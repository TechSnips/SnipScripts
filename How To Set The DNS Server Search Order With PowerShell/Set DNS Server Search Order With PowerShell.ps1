#How To Set The DNS Server Search Order With PowerShell

#View the DNS server search order for the system
Get-DnsClientServerAddress

#Set the new DNS server search order, adding the new server and removing the old one.
Set-DnsClientServerAddress -InterfaceIndex 7 -ServerAddresses 192.168.2.61,192.168.2.51

#Verify the changes
Get-DnsClientServerAddress -InterfaceIndex 7 -AddressFamily IPv4

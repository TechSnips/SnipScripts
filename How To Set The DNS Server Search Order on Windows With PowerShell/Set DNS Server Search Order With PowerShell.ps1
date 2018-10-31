#View the DNS server search order for the system
Get-DnsClientServerAddress

#Use nslookup to show the primary DNS server address
nslookup file01.corp.ad

#Set the new DNS server search order, adding the new server and removing the old one.
Set-DnsClientServerAddress -InterfaceIndex 7 -ServerAddresses 192.168.2.51,192.168.2.52

#Verify the changes
Get-DnsClientServerAddress -InterfaceIndex 7 -AddressFamily IPv4

#Use nslookup to verify the primary DNS server address has been changed
nslookup file01.corp.ad

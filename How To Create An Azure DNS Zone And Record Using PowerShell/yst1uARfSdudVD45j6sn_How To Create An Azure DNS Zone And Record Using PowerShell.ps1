
#Connect-AzureRmAccount

New-AzureRMResourceGroup -name DNSZones -location "westeurope"

New-AzureRmDnsZone -Name domain.com -ResourceGroupName DNSZones

Get-AzureRmDnsZone

Get-AzureRmDnsRecordSet -ZoneName domain.com -resourcegroupname DNSZones

New-AzureRmDnsRecordSet -Name www -RecordType A -ZoneName domain.com -ResourceGroupName DNSZones -Ttl 3600 -DnsRecords (New-AzureRmDnsRecordConfig -IPv4Address "10.10.10.10")

Remove-AzureRmDnsRecordSet -name ww -RecordType CNAME -ZoneName domain.com -ResourceGroupName DNSZones

Remove-AzureRmDnsZone -Name domain.com -ResourceGroupName DNSZones
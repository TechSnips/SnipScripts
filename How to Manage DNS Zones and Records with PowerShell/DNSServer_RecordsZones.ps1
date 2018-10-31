#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Remove-DnsServerZone 'northamerica.techsnipsdemo.org' -force
Remove-DnsServerZone 'europe.techsnipsdemo.org' -force
Remove-DnsServerZone '2.0.10.in-addr.arpa' -force
Invoke-Command -ComputerName DNS01 -ScriptBlock {
    Remove-DnsServerZone 'northamerica.techsnipsdemo.org' -force
    Remove-DnsServerZone '2.0.10.in-addr.arpa' -force
}
Remove-DnsServerResourceRecord -Name 'ntp01' -RRType A -ZoneName 'techsnipsdemo.org' -Force
Remove-DnsServerResourceRecord -Name 'server' -RRType CName -ZoneName 'techsnipsdemo.org' -Force
Remove-DnsServerResourceRecord -Name '@' -RRType Mx -ZoneName 'techsnipsdemo.org' -Force
Remove-DnsServerResourceRecord -Name '_sip._tcp' -RRType SRV -ZoneName 'techsnipsdemo.org' -Force
Function Prompt(){}
Clear-Host
#endregion

#prerequisite
Get-Module DNSServer

#region Getting current zones
#All zones
Get-DnsServerZone

#Remote DNS server
Get-DnsServerZone -ComputerName DNS01

#Specific zone
Get-DnsServerZone 'techsnipsdemo.org'

#endregion

#region Adding a primary zone

#AD integrated
Add-DnsServerPrimaryZone -Name 'northamerica.techsnipsdemo.org' -ReplicationScope 'Forest'
#Replication scope options: Forest,Domain,Legacy,Custom

#File backed
Add-DnsServerPrimaryZone -Name 'europe.techsnipsdemo.org' -ZoneFile 'europe.techsnipsdemo.org.dns'

#Reverse lookup
Add-DnsServerPrimaryZone -NetworkID '10.0.2.0/24' -ReplicationScope 'Domain'

#Verify
Get-DnsServerZone

#endregion

#Remote to secondary DNS server
Enter-PSSession DNS01

#region Adding a secondary zone
#Secondary zone
$SecondaryNA = @{
    Name = 'northamerica.techsnipsdemo.org'
    ZoneFile = 'northamerica.techsnipsdemo.org.dns'
    MasterServers = '10.2.2.2'
}
Add-DnsServerSecondaryZone @SecondaryNA

#Secondary reverse lookup zone
$SecondaryRL = @{
    NetworkID = '10.0.2.0/24'
    ZoneFile = '2.0.10.in-addr.arpa.dns'
    MasterServers = '10.2.2.2'
}
Add-DnsServerSecondaryZone @SecondaryRL

#Verify
Get-DnsServerZone

#endregion

#Close remote session
Exit-PSSession

#region removing a zone
Remove-DnsServerZone -Name 'europe.techsnipsdemo.org' -Force

#Verify
Get-DnsServerZone

#endregion

#region Adding a resource record

#A record
Add-DnsServerResourceRecord -A -Name "ntp01" -ZoneName "techsnipsdemo.org" -IPv4Address "10.0.2.200"

#CNAME
$CNAMERecord = @{
    CName = $True
    Name = 'server'
    HostNameAlias = 'dc01.techsnipsdemo.org'
    ZoneName = 'techsnipsdemo.org'
    TimeToLive =  '01:00:00'
}
Add-DnsServerResourceRecord @CNAMERecord

#MX
$MXRecord = @{
    MX = $True
    Name = '.'
    ZoneName = "techsnipsdemo.org"
    MailExchange = "ex01.techsnipsdemo.org"
    Preference = 10
}
Add-DnsServerResourceRecord @MXRecord

#SRV
$SRVRecord = @{
    SRV = $True
    Name = '_sip._tcp'
    DomainName = "sipdir.online.lync.com"
    Priority = 100
    Weight = 10
    Port = 443
    TimeToLive = '00:10:00'
    ZoneName = 'techsnipsdemo.org'
}
Add-DnsServerResourceRecord @SRVRecord

#Verify
Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org'

#endregion

#region Editting a resource record

#change the TTL
$old = $new = Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org' -Name '_sip._tcp' -RRType 'SRV'
$new.TimeToLive = [timespan]'01:00:00'

Set-DnsServerResourceRecord -NewInputObject $new -OldInputObject $old -ZoneName 'techsnipsdemo.org' -PassThru

#changing the IP
$old = Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org' -Name 'ntp01' -RRType 'A'
$new = $old.Clone()
$new.RecordData.IPv4Address = [ipaddress]'10.2.2.220'

Set-DnsServerResourceRecord -NewInputObject $new -OldInputObject $old -ZoneName 'techsnipsdemo.org'

#Verify
Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org'

#endregion

#region Removing a resource record
Remove-DnsServerResourceRecord -Name 'server' -RRType CNAME -ZoneName 'techsnipsdemo.org' -Force

#Verify
Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org'

#endregion
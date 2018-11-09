#Retrieve a list of Firewall Rules
Get-NetFirewallRule
Get-NetFirewallRule -Direction Inbound | Select-Object -Property DisplayName,Profile,Enabled

#Filter the options for Inbound Rule and select a few properties and sort the list
$InboundRules = Get-NetFirewallRule -Direction Inbound | Select-Object -Property DisplayName,Profile,Enabled
$InboundRules | Sort-Object -Property DisplayName

#Filter the options a bit more - Inbound Rules for the Domain profile
$InboundRulesDomain = Get-NetFirewallRule -Direction Inbound | Where-Object {$_.Profile -EQ "Domain" -or $_.Profile -EQ "Any"}
$InboundRulesDomain | Select-Object -Property DisplayName,Profile,Enabled | Sort-Object -Property DisplayName
$InboundRulesDomain | Select-Object -Property DisplayName,Profile,Enabled | Export-Csv -Path "C:\FireWallReport.csv"
Import-Csv -Path "C:\FireWallReport.csv" | Out-GridView

#Retrieve details about protocol and port information from the same data
$InboundDomainPorts = $InboundRulesDomain | Get-NetFirewallPortFilter | Select-Object -Property InstanceID,Protocol,LocalPort,RemotePort
$InboundDomainPorts | Sort-Object -Property InstanceID
$InboundDomainPorts | Export-Csv -Path "C:\FireWallPortReport.csv"
Import-Csv -Path "C:\FireWallPortReport.csv" | Out-GridView
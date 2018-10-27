#Retreive a list of Firewall Profiles
Get-NetFirewallProfile
Get-NetFirewallProfile -Name Domain
Get-NetFirewallProfile | Where-Object -Property Enabled -EQ "True" | Select-Object -Property Name,Enabled

#Retrieve a list of Firewall Rules
Get-NetFirewallRule
Get-NetFirewallProfile -Name Domain | Get-NetFirewallRule
Get-NetFirewallRule -Direction Inbound | Select-Object -Property DisplayName

$InboundRules = Get-NetFirewallRule -Direction Inbound
$InboundRules | Select-Object -Property DisplayName,Profile,Enabled | Sort-Object -Property DisplayName

$InboundRulesDomain = Get-NetFirewallRule -Direction Inbound | Where-Object {$_.Profile -EQ "Domain" -or $_.Profile -EQ "Any"}
$InboundRulesDomain | Select-Object -Property DisplayName,Profile,Enabled | Sort-Object -Property DisplayName
$InboundRulesDomain | Select-Object -Property DisplayName,Profile,Enabled | Export-Csv -Path "C:\FireWallReport.csv"
Import-Csv -Path "C:\FireWallReport.csv" | Out-GridView

#Retrieve details about a specific firewall rule
Get-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)"
Get-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)" | Select-Object -Property DisplayName,Profile,Enabled,Direction,Action
Get-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-In)" | Get-NetFirewallPortFilter
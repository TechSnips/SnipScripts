#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Remove-DhcpServerv4Scope -ScopeId 10.3.0.0
Function Prompt(){}
Clear-Host
#endregion

#region Create new scope

#Create the scope
$Scope = @{
    Name = 'Corporate'
    StartRange = '10.3.0.20'
    EndRange = '10.3.1.220'
    SubnetMask = '255.255.254.0'
    State = 'Active'
    LeaseDuration = New-TimeSpan -Days 1
}
Add-DhcpServerv4Scope @Scope

#Verify
Get-DhcpServerv4Scope -ScopeId 10.3.0.0

#Create the exclusion range
$ExclusionRange = @{
    ScopeID = '10.3.0.0'
    StartRange = '10.3.0.1'
    EndRange = '10.3.0.20'
}
Add-DhcpServerv4ExclusionRange @ExclusionRange

#Verify
Get-DhcpServerv4ExclusionRange -ScopeId 10.3.0.0

#Add the gateway
$GatewayOption = @{
    ScopeID = '10.3.0.0'
    OptionID = 3
    Value = '10.3.0.1'
}
Set-DhcpServerv4OptionValue @GatewayOption

#Verify
Get-DhcpServerv4OptionValue -ScopeId 10.3.0.0 -OptionId 3

#Add the DNS servers
$DNSOption = @{
    ScopeId = '10.3.0.0'
    DnsDomain = 'techsnipsdemo.org'
    DnsServer = '10.2.2.2','10.2.2.3'
}
Set-DhcpServerv4OptionValue @DNSOption

#Verify
Get-DhcpServerv4OptionValue -ScopeId 10.3.0.0

#endregion

#region Edit the scope

#Get the scope
Get-DhcpServerv4Scope -ScopeID 10.3.0.0

#Edit the scope lease
$LeaseDuration = New-TimeSpan -Hours 12
Set-DhcpServerv4Scope -ScopeID 10.3.0.0 -LeaseDuration $LeaseDuration

#Verify
Get-DhcpServerv4Scope -ScopeID 10.3.0.0

#Disable the scope
Set-DhcpServerv4Scope -ScopeID 10.3.0.0 -State Inactive

#Verify
Get-DhcpServerv4Scope -ScopeID 10.3.0.0

#Remove the scope
Remove-DhcpServerv4Scope -ScopeID 10.3.0.0

#endregion
#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Retrieving existing subnets

# First, retrieving sites
Get-ADReplicationSite

$site = Get-ADReplicationSite

# Find all subnets
Get-ADReplicationSubnet -Filter *

#endregion 

#region Adding a new subnet

# Create the subnet
# Name is CIDR notation
New-ADReplicationSubnet -Name '192.168.200.0/24' -Site $site.Name

# Retrieve the new subnet
Get-ADReplicationSubnet -Filter {Site -eq $site.name}

#region Adding multiple

$subnets = 20..25 | %{"192.168.$_.0/24"}
foreach($subnet in $subnets){
    New-ADReplicationSubnet -Name $subnet -Site $site.Name
}

# Verification
Get-ADReplicationSubnet -Filter {Site -eq $site.Name} | Format-Table Name

#endregion

#endregion

#region
# Create a new security group with one rule
$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName SNIP -Location uksouth -Name `
    "NSG-FrontEnd" -SecurityRules $rule1
#endregion

#region
# Add a rule to an existing NSG
$nsg = Get-AzureRmNetworkSecurityGroup
Add-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -name web-rule -Description "Allow Http" `
       -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix `
       Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 `
| Set-AzureRmNetworkSecurityGroup 
#endregion

#region
# Retrieve a rule, then remove that rule
Get-AzureRmNetworkSecurityGroup -Name  "NSG-FrontEnd" -ResourceGroupName SNIP `
    | Get-AzureRmNetworkSecurityRuleConfig -Name "rdp-rule"
$nsg = Get-AzureRmNetworkSecurityGroup -Name  "NSG-FrontEnd" -ResourceGroupName SNIP 
Remove-AzureRmNetworkSecurityRuleConfig -Name "rdp-rule" -NetworkSecurityGroup $nsg `
| Set-AzureRmNetworkSecurityGroup
#endregion

#region
# Modify an existing rule
$nsg = Get-AzureRmNetworkSecurityGroup -Name "NSG-FrontEnd" -ResourceGroupName SNIP
Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -name web-rule -Description "Allow Http" `
       -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix `
       Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 8080 `
       | Set-AzureRmNetworkSecurityGroup
#endregion

#region
# Attach NSG to a Virtual Network
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName SNIP -Name snipVnet
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name front-end
$nsg = Get-AzureRmNetworkSecurityGroup -Name "NSG-FrontEnd" -ResourceGroupName SNIP
$subnet.NetworkSecurityGroup = $nsg
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

# Detach NSG from a virtual Network
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName SNIP -Name snipVnet
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name front-end
$nsg = Get-AzureRmNetworkSecurityGroup -Name "NSG-FrontEnd" -ResourceGroupName SNIP
$subnet.NetworkSecurityGroup = $null
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
#endregion

#region
Remove-AzureRmNetworkSecurityGroup -name "NSG-FrontEnd" -ResourceGroupName SNIP -Force
#endregion 
#region
$newVNetParams = @{
    'Name'              = 'snipVnet'
    'ResourceGroupName' = 'SNIP'
    'Location'          = 'uksouth'
    'AddressPrefix'     = '10.0.0.0/16'
}
$vNet = New-AzureRmVirtualNetwork @newVNetParams -Verbose
#endregion

#region
$vnet  = Get-AzureRmVirtualNetwork -Name snipVnet -ResourceGroupName SNIP
$vnet.AddressSpace
$vnet.Name
Add-AzureRmVirtualNetworkSubnetConfig -Name snipSubNet1 -AddressPrefix 10.0.0.0/24 -VirtualNetwork $vnet 
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
#endregion

#region
Get-AzureRMVirtualNetwork
(Get-AzureRMVirtualNetwork).Name
(Get-AzureRMVirtualNetwork).AddressSpace
(Get-AzureRMVirtualNetwork).Subnets.Addressprefix
#endregion

#region
Remove-AzureRmVirtualNetwork -Name snipVnet -ResourceGroupName SNIP -Force
#endregion

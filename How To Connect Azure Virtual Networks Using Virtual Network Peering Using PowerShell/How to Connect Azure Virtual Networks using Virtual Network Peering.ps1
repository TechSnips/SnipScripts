#region
$vnet1 = Get-AzureRmVirtualNetwork -ResourceGroupName <resource group> -Name Vnet1
$vnet2 = Get-AzureRmVirtualNetwork -ResourceGroupName <resource group> -Name Vnet2
#endregion

#region
Add-AzureRmVirtualNetworkPeering -Name 'LinkVnet1ToVnet2' -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.Id
Add-AzureRmVirtualNetworkPeering -Name 'LinkVnet2ToVnet1' -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.Id
#endregion

#region
Get-AzureRmVirtualNetworkPeering -ResourceGroupName <resource group> -VirtualNetworkName $vnet1.Name | select PeeringState
#endregion
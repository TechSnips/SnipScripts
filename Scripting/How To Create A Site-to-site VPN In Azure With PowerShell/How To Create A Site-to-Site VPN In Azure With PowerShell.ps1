#region
# Add a gateway subnet
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName SNIP -Name snipVNet
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet
# Set the subnet configuration for the virtual network
$vnet | Set-AzureRmVirtualNetwork
#endregion

#region
# Request a public IP address
$gwpip = New-AzureRmPublicIpAddress -Name snipGWIP -ResourceGroupName SNIP -Location 'uk south' -AllocationMethod Dynamic
#endregion

#region
# Create the gateway IP address configuration
$vnet = Get-AzureRmVirtualNetwork -Name snipVNet -ResourceGroupName SNIP
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id
#endregion

#region
# Create the VPN gateway
New-AzureRmVirtualNetworkGateway -Name snipVnetGW -ResourceGroupName SNIP `
    -Location 'uk south' -IpConfigurations $gwipconfig -GatewayType Vpn `
    -VpnType RouteBased -GatewaySku "Basic"
# Create the local network gateway
New-AzureRmLocalNetworkGateway -Name Site1 -ResourceGroupName SNIP `
    -Location 'uk south' -GatewayIpAddress 'xxx.xxx.xxx.xxx' -AddressPrefix @('192.168.7.0/24','10.200.0.0/24')
#endregion

#region
# Configure your on-premises VPN device
# Create the VPN connection
$gateway1 = Get-AzureRmVirtualNetworkGateway -Name snipVNetGW -ResourceGroupName SNIP
$local = Get-AzureRmLocalNetworkGateway -Name Site1 -ResourceGroupName SNIP
New-AzureRmVirtualNetworkGatewayConnection -Name snipVNettoSite1 -ResourceGroupName SNIP `
    -Location 'UK South' -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local `
    -ConnectionType IPsec -RoutingWeight 10 -SharedKey 'xxxxxxxxxxxx'
#endregion

# Retrieve Public IP Address
(Get-AzureRmPublicIpAddress -Name snipGWIP -ResourceGroupName SNIP).IpAddress
## Prereqs: AzureRm PowerShell module
## Install-Module AzureRm

Connect-AzureRmAccount -Subsription 'Visual Studio Enterprise: BizSpark'

## Find the network interface name of the VM
$vm = Get-AzureRmVM -Name SRV2 -ResourceGroupName adbtesting
$vm
$vm.NetworkProfile
$vm.NetworkProfile[0].NetworkInterfaces
$vm.NetworkProfile[0].NetworkInterfaces.Id
$nicName = $vm.NetworkProfile[0].NetworkInterfaces.Id.Split('/')[-1]
$nicName

## Find the public IP ID
$nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $vm.ResourceGroupName
$nic.IpConfigurations
$nic.IpConfigurations.publicIpAddress
$pubIpId = $nic.IpConfigurations.publicIpAddress.Id
$pubIpId

## Find the public IP using the ID of the public IP address
$pubIpObject = Get-AzureRmPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where-Object { $_.Id -eq $pubIpId }
$pubIpObject
$pubIpObject.IpAddress

function Get-AzurePublicIp {
    [CmdletBinding()]
    param(
        [parameter()]
        $VmName,

        [parameter()]
        $ResourceGroup
    )

    $vm = Get-AzureRmVM -Name $VmName -ResourceGroupName $ResourceGroup
    $nicName = $vm.NetworkProfile[0].NetworkInterfaces.Id.Split('/')[-1]

    ## Find the public IP ID
    $nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $vm.ResourceGroupName
    $pubIpId = $nic.IpConfigurations.publicIpAddress.Id

    ## Find the public IP using the ID of the public IP address
    $pubIpObject = Get-AzureRmPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where-Object { $_.Id -eq $pubIpId }
    $pubIpObject.IpAddress
}
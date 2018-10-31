New-AzureRmResourceGroup -Name 'MyResourceGroup' -Location 'West US'

$newSubnetParams = @{
    'Name' = 'MySubnet'
    'AddressPrefix' = '10.0.1.0/24'
}
$subnet = New-AzureRmVirtualNetworkSubnetConfig @newSubnetParams

$newVNetParams = @{
    'Name' = 'MyNetwork'
    'ResourceGroupName' = 'MyResourceGroup'
    'Location' = 'West US'
    'AddressPrefix' = '10.0.0.0/16'
}
$vNet = New-AzureRmVirtualNetwork @newVNetParams -Subnet $subnet

$newStorageAcctParams = @{
    'Name' = 'mystorageaccount' ## Must be globally unique and all lowercase
    'ResourceGroupName' = 'MyResourceGroup'
    'Type' = 'Standard_LRS'
    'Location' = 'West US'
}
$storageAccount = New-AzureRmStorageAccount @newStorageAcctParams

$newPublicIpParams = @{
    'Name' = 'MyNIC'
    'ResourceGroupName' = 'MyResourceGroup'
    'AllocationMethod' = 'Dynamic' ## Dynamic or Static
    'DomainNameLabel' = 'test-domain'
    'Location' = 'West US'
}
$publicIp = New-AzureRmPublicIpAddress @newPublicIpParams

$newVNicParams = @{
    'Name' = 'MyNic'
    'ResourceGroupName' = 'MyResourceGroup'
    'Location' = 'West US'
}
$vNic = New-AzureRmNetworkInterface @newVNicParams -SubnetId $vNet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

$newConfigParams = @{
    'VMName' = 'MyVM'
    'VMSize' = 'Standard_A3'
}
$vmConfig = New-AzureRmVMConfig @newConfigParams

$newVmOsParams = @{
    'Windows' = $true
    'ComputerName' = 'MyVM'
    'Credential' = (Get-Credential -Message 'Type the name and password of the local administrator account.')
    'ProvisionVMAgent' = $true
    'EnableAutoUpdate' = $true
}
$vm = Set-AzureRmVMOperatingSystem @newVmOsParams -VM $vmConfig

$newSourceImageParams = @{
    'PublisherName' = 'MicrosoftWindowsServer'
    'Version' = 'latest'
    'Skus' = '2012-R2-Datacenter'
}
 
$offer = Get-AzureRmVMImageOffer -Location 'West US' –PublisherName 'MicrosoftWindowsServer'
 
$vm = Set-AzureRmVMSourceImage @newSourceImageParams -VM $vm -Offer $offer.Offer

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $vNic.Id

$osDiskName = 'myDisk'
$osDiskUri = $storageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $vmName + $osDiskName + ".vhd"
 
$newOsDiskParams = @{
    'Name' = 'OSDisk'
    'CreateOption' = 'fromImage'
}
 
$vm = Set-AzureRmVMOSDisk @newOsDiskParams -VM $vm -VhdUri $osDiskUri

New-AzureRmVM -VM $vm -ResourceGroupName MyResourceGroup -Location 'West US'

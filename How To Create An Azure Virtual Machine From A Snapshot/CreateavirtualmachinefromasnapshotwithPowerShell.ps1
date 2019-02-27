#Provide the subscription Id
$subscriptionId = 'subscription id'

#Provide the name of your resource group
$resourceGroupName ='resource group'

#Provide the name of the snapshot that will be used to create OS disk
$snapshotName = 'snapshot name'

#Provide the name of the OS disk that will be created using the snapshot
$osDiskName = 'NewOSDisk'

#Provide the name of an existing virtual network where virtual machine will be created
$virtualNetworkName = 'vnet'

#Provide the name of the virtual machine
$VMname = 'NewVMfromSnapshot'

<#Provide the size of the virtual machine
e.g. Standard_DS3
Get all the vm sizes in a region using below script:
e.g. Get-AzureRmVMSize -Location ukwest #>
$virtualMachineSize = 'Standard_B1s'

#Connect to Azure
Connect-AzureRmAccount 

#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName

#Use splatting to declare common parameters
$Location = $snapshot.Location

$params = @{
  ResourceGroupName = "$resourceGroupName"
  Location = "$Location"
}

$diskConfig = New-AzureRmDiskConfig -Location $Location -SourceResourceId $snapshot.Id -CreateOption Copy
 
$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $osDiskName

#Initialize virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName $VMname -VMSize $virtualMachineSize

#Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows

#Create a public IP for the VM
$publicIp = New-AzureRmPublicIpAddress -Name ($VMname.ToLower()+'_ip') -AllocationMethod Dynamic @params 

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network
$nic = New-AzureRmNetworkInterface -Name ($VMname.ToLower()+'_nic') -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id @params

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine @params
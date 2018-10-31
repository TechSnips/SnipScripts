#region Prerequisites
# Connect to Azure
Connect-AzureRmAccount

#endregion

#region Create
# Resource group to use
$resourceGroup = Get-AzureRmResourceGroup -Name 'Anthony_Containers'

$ContainerParams = @{
    ResourceGroupName = $resourceGroup.ResourceGroupName
    Name = 'supertscontainer'
    Image = 'microsoft/iis:nanoserver'
    OsType = 'Windows'
    DnsNameLabel = 'supertscontainer'
}
New-AzureRmContainerGroup @ContainerParams

#endregion

#region  Monitor
$getContainerParams = @{
    ResourceGroupName = $resourceGroup.ResourceGroupName
    Name = $ContainerParams.Name
}
Get-AzureRmContainerGroup @getContainerParams

#endregion
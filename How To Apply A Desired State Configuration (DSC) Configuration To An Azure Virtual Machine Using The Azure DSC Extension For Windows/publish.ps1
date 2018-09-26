#region
Connect-AzureRmAccount
#endregion

#region
$resourceGroup = 'xxxxxx'
$vmName = 'TESTVM'
$storageName = 'xxxxxxxx'

$parameters = @{
    'configurationpath'  = '.\webserver-install.ps1'
    'resourcegroupname'  = $resourceGroup
    'StorageAccountName' = $storagename
}
Publish-AzureRmVMDscConfiguration @parameters -force -Verbose
#endregion

#region
$parameters = @{
    'Version'           = '2.76'
    'ResourcegroupName' = $resourceGroup
    'VMname'            = $vmName
    'ArchiveStorageAccountName' = $storageName
    'ArchiveBlobName'           = 'webserver-install.ps1.zip'
    'AutoUpdate'                = $true
    'ConfigurationName'         = 'webserver'
}
Set-AzureRmVMDscExtension @parameters -verbose
#endregion

#region
$results =  Get-AzureRmVMDscExtensionStatus -ResourceGroupName $resourceGroup -VMName TESTVM
$results
$results.DscConfigurationLog
#endregion
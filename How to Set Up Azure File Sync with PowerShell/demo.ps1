## More information: https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-files-deployment-guide?tabs=powershell

#region Disable IE Enhanced Security Configuration. 

## This is necessary during the initial registration process but can be turned back on later

$AdminKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
$UserKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
Set-ItemProperty -Path $AdminKey -Name 'IsInstalled' -Value 0
Set-ItemProperty -Path $UserKey -Name 'IsInstalled' -Value 0
Stop-Process -Name Explorer

#endregion

#region Create the Azure File Share

## This is what the File Sync agent will connect to to copy files to the storage account

$resourceGroup = 'TechSnipsBackEnd'
$storageAccountName = 'techsnips'

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName | select -first 1).Value
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
$share = New-AzureStorageShare -Name ipswitchfileshare -Context $storageContext

#endregion

#region Install the FileSync Agent. 

## Accept all defaults

$downloadUri = 'https://download.microsoft.com/download/1/8/D/18DC8184-E7E2-45EF-823F-F8A36B9FF240/StorageSyncAgent_V3_WS2016.EXE'
Invoke-WebRequest -Uri $downloadUri -OutFile 'C:\filesyncagent.exe'
Invoke-Item 'C:\filesyncagent.exe'

#endregion

#region Create the Storage Sync Service. 

## The region is important here. The region must be the same as the storage account

$agentPath = 'C:\Program Files\Azure\StorageSyncAgent' ## Make sure to change this if the default path was not used
$region = 'East US 2' ## This needs to be in the same region as the storage account
$resourceGroup = 'SharedLab'
$storageSyncName = 'TechSnipsStorageSync'
Import-Module "$agentPath\StorageSync.Management.PowerShell.Cmdlets.dll"

$subscription = Get-AzureRmSubscription -SubscriptionName 'TechSnips'

Login-AzureRmStorageSync –SubscriptionId $subscription.Id -ResourceGroupName $resourceGroup -TenantId $subscription.TenantID -Location $region

New-AzureRmStorageSyncService -StorageSyncServiceName $storageSyncName

#endregion

#region Register the Windows Server

$registeredServer = Register-AzureRmStorageSyncServer -StorageSyncServiceName $storageSyncName

#endregion

#region Create the Sync Group

$syncGroupName = 'TechSnipsSyncGroup'
New-AzureRmStorageSyncGroup -SyncGroupName $syncGroupName -StorageSyncService $storageSyncName

#endregion

#region Create the Cloud Endpoint

$parameters = @{
    StorageSyncServiceName = $storageSyncName
    SyncGroupName = $syncGroupName
    StorageAccountResourceId = $storageAccount.Id
    StorageAccountShareName = 'ipswitchfileshare'
}
New-AzureRmStorageSyncCloudEndpoint @parameters

#endregion

#region Create the Server Endpoint

## This defines the folder path on the on-prem server that will set up to sync with Azure storage

New-AzureRmStorageSyncServerEndpoint -StorageSyncServiceName $storageSyncName -SyncGroupName $syncGroupName -ServerId $registeredServer.Id -ServerLocalPath 'C:\FileSyncDemo'

#endregion

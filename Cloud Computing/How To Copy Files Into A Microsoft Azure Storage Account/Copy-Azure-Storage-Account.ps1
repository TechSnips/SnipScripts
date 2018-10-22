Install-Module AzureRm

Connect-AzureRmAccount

# List all Storage Accounts on the connected tenant
Get-AzureRmStorageAccount | Select StorageAccountName

# Store deisred account in variable
$StorageAccount = Get-AzureRmStorageAccount | where {$_.StorageAccountName -eq 'powershelldepot'}

# Check for existance of storage blobs
$StorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob

# Create, and store, new container
$StorageAccount | New-AzureRmStorageContainer -Name 'demo'
$Container = $StorageAccount | Get-AzureStorageContainer

# Upload single file
$Container | Set-AzureStorageBlobContent -File 'D:\ImportantData.txt' -Blob 'Important!'

# Upload multiple files
Get-ChildItem -Path D:\Scripts | foreach {
    $Container | Set-AzureStorageBlobContent -File $_.FullName -Blob $_.BaseName
}
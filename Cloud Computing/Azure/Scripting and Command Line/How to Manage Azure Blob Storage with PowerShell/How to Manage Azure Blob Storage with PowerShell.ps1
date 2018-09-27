<#
Pre-reqs:

    The 'AzureRM' PowerShell module
    Install-Module AzureRM

    Connect-AzureRmAccount
#>


$StorageAccount = Get-AzureRmStorageAccount -Name snipsblobs -ResourceGroupName rg-we-snipsblobs


#region List out all the blobs

Get-AzureStorageContainer -Context $StorageAccount.Context

Get-AzureStorageBlob -Container "docs" -Blob * -Context $StorageAccount.Context

Get-AzureStorageContainer -Context $StorageAccount.Context | Get-AzureStorageBlob -Context $StorageAccount.Context


#endregion



#region download blobs

Get-AzureStorageBlobContent -Container docs -Blob DS-Ipswitch-Analytics.pdf -Destination "C:\blobs\" -Context $StorageAccount.Context

Get-AzureStorageBlob -Container "docs" -Blob * -Context $StorageAccount.Context | Get-AzureStorageBlobContent  -Destination "C:\blobs\" -Context $StorageAccount.Context

#endregion



#region Deleting a blob

Remove-AzureStorageBlob -Container "docs" -Blob "DS-Ipswitch-Analytics.pdf" -Context $StorageAccount.Context

Get-AzureStorageBlob -Container "docs" -Blob * -Context $StorageAccount.Context | Remove-AzureStorageBlob

#endregion



#region upload blobs

Set-AzureStorageBlobContent -Container "docs" -Blob DS-Ipswitch-Analytics.pdf -File C:\Blobs\DS-Ipswitch-Analytics.pdf -Context $StorageAccount.Context 

Get-ChildItem C:\Blobs | Set-AzureStorageBlobContent -Container "docs" -Context $StorageAccount.Context -Force

#endregion



#region Copy blobs between containers

Get-AzureStorageContainer -Context $StorageAccount.Context | Get-AzureStorageBlob -Context $StorageAccount.Context

Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob ipswitch.iso -DestContainer iso02 -DestBlob ipswitch.iso -Context $StorageAccount.Context

Get-AzureStorageBlob -Container iso -Blob "*.iso" -Context $StorageAccount.Context | Start-AzureStorageBlobCopy -DestContainer iso02

Get-AzureStorageBlobCopyState -Blob "Windows10_x64.iso" -Container "iso02" -Context $StorageAccount.Context

#endregion



#region Rename a blob

Get-AzureStorageBlob -Container "iso" -Blob * -Context $StorageAccount.Context

Start-AzureStorageBlobCopy -SrcContainer iso -SrcBlob Windows10_x64.iso  -DestContainer iso -DestBlob Windows10_x64_002.iso  -Context $StorageAccount.Context

Remove-AzureStorageBlob -Container "iso" -Blob "Windows10_x64.iso" -Context $StorageAccount.Context

#endregion



#region Taking a snapshot of a blob

$ReadmeBlob = Get-AzureStorageBlob -Container docs -Blob Readme.txt -Context $StorageAccount.Context

$ReadmeBlob.ICloudBlob.CreateSnapshot()

$snapshots = Get-AzureStorageBlob -Container docs -prefix Readme.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

#endregion



#region Restoring a snapshot

Get-AzureStorageBlob -Container docs -Blob Readme.txt -Context $StorageAccount.Context

$snapshots = Get-AzureStorageBlob -Container docs -prefix Readme.txt -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

$snapshots | Out-GridView -PassThru | Start-AzureStorageBlobCopy -DestContainer docs -Force

#endregion



#region delete snapshots

$snapshots = Get-AzureStorageBlob -Container docs -Context $StorageAccount.Context | Where-Object {$_.ICloudBlob.IsSnapshot -and $_.SnapshotTime -ne $null}

$snapshots | Remove-AzureStorageBlob

#endregion


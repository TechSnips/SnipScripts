#region
# Username
Azure\nrstorageaccount
#Password
xxxxxxxxxxxxxxxx
#Share Name
\\<storageaccount>.file.core.windows.net\logs
#endregion

#region
$parameters = @{
StorageAccountName = '<storageaccount>'
StorageAccountKey = 'xxxxxxxxxxxxxxxxxxxx'
}
$storageContext = New-AzureStorageContext @parameters
New-AzureStorageShare logs -Context $storageContext

# ! Alert - The name of your file share must be all lowercase !
#endregion

#region
$parameters = @{
    String  = 'xxxxxxxxxxxxxxx'
    AsPlainText = $True
    Force = $true
}
$acctKey = ConvertTo-SecureString @parameters

$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\<storageaccount>", $acctKey
New-PSDrive -Name P -PSProvider FileSystem -Root "\\<storageaccount>.file.core.windows.net\logs" -Credential $credential
Remove-PSDrive P
#endregion
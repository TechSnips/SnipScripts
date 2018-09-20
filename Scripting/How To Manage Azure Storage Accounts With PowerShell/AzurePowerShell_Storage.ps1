
# Azure PowerShell module version 4.4 or later.
# Install-Module AzureRM

Get-Module -ListAvailable AzureRM

Connect-AzureRmAccount

#region Use an existing storage account

Get-AzureRMStorageAccount 

$resourceGroup = "AzureDemo"
$storageAccountName = "existingstoragemm1"

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName

$storageAccount

#endregion


#region Creating a Storage Account

# Get list of locations and select one.
Get-AzureRmLocation | select Location 
$location = "eastus"

# Create a new resource group.
$resourceGroup = "AzureDemo2"
New-AzureRmResourceGroup -Name $resourceGroup -Location $location 

# Set the name of the storage account and the SKU name. 
$storageAccountName = "newstoragemm1"  # Numbers and Lowercase letters only
$skuName = "Standard_LRS"

<# SkuName - The acceptable values for this parameter are:
    Standard_LRS - Locally-redundant storage.
    Standard_ZRS - Zone-redundant storage.
    Standard_GRS - Geo-redundant storage.
    Standard_RAGRS - Read access geo-redundant storage.
    Premium_LRS - Premium locally-redundant storage. You cannot change Standard_ZRS and Premium_LRS types to other account types. 
    You cannot change other account types to Standard_ZRS or Premium_LRS.
#>

# Create the storage account.
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName `
  -Location $location `
  -SkuName $skuName

$storageAccount

# Retrieve the context. 
$storageAccount.Context

#endregion


#region Manage a storage account

# Set the storage account type
Set-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -SkuName Standard_RAGRS

# Set tags for a storage account
Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName | select Tags

Set-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Tag @{tag0="Value100";tag1="Value110";tag2="Value120"}

#endregion


#region Manage Access Keys

Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup -Name $storageAccountName

$oldKey = `
    (Get-AzureRmStorageAccountKey `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccountName).Value[0]

$oldKey

New-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -KeyName key1 

$newKey = (Get-AzureRmStorageAccountKey `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccountName).Value[0]

$oldKey
$newKey

#endregion


#region Delete a Storage Accoung

Remove-AzureRmStorageAccount -ResourceGroup $resourceGroup -AccountName $storageAccountName

Remove-AzureRmResourceGroup -Name $resourceGroup

#endregion
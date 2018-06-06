# SharePoint Patterns & Practices (aka PnP)
# Available on GitHub >> https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets?view=sharepoint-ps

#############################################
#region CREATE Lists & Libraries
$creds = Get-Credential

#Connect to the Site Collection - ENTER YOUR OWN SITE COLLECTION
Connect-PnPOnline -Url https://<TENANT-NAME>.sharepoint.com/sites/techsnips -Credentials $creds

#Create a Contact List
New-PnPList -Title "Client List" -Template Contacts -OnQuickLaunch

#Create a Document Library
New-PnPList -Title "Marketing" -Template DocumentLibrary -OnQuickLaunch

#Create MULTIPLE Lists or Libraries from Csv file
$CsvFile = Import-Csv -Path C:\Users\$env:USERNAME\Desktop\ListsToCreate.csv
foreach ($List in $CsvFile) {
    New-PnPList -Title $List.Title -Template $List.Template -OnQuickLaunch
}
#endregion

############################################
#region MODIFY Lists & Libraries
#Example 1
Set-PnPList -Identity "Marketing" -ForceCheckout $true -EnableVersioning $true -MajorVersions 5

#Example 2
Set-PnPList -Identity "Client List" -Title "Customers" -Description "Valuable clients for the Company"
#endregion

############################################
#region REMOVE Lists & Libraries
#Remove ONE List or Library
Remove-PnPList -Identity "Customers" -Recycle -Force

#Remove MULTIPLE Lists or Libraries
$CsvFile = Import-Csv -Path C:\Users\$env:USERNAME\Desktop\ListsToDelete.csv
foreach ($List in $CsvFile) {
    Remove-PnPList -Identity $List.Title -Force
}
#endregion

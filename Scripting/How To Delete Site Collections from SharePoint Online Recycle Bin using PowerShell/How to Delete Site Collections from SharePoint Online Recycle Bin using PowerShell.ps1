#Connect to SharePoint Online Admin Center
$creds = Get-Credential
Connect-SPOService -Url https://<TENANT-NAME>-admin.sharepoint.com -Credential $creds

#Retrieve the Site Collections currently in the SPO Recycle Bin
Get-SPODeletedSite

#region Delete ONE Site Collection - ENTER YOUR OWN SITE COLLECTION
    Remove-SPODeletedSite -Identity https://<TENANT-NAME>-admin.sharepoint.com/teams/techsnips
#endregion

#region Delete MULTIPLE Site Collections using Csv File
    $CsvFile = Import-Csv -Path "C:\Users\$env:USERNAME\Desktop\SitesToDelete.csv"
    foreach ($site in $CsvFile) {
        Remove-SPODeletedSite -Identity $site.Url
    }
#endregion

#region Delete ALL Site Collections from the Recycle Bin
    Get-SPODeletedSite | Remove-SPODeletedSite -Confirm:$false
#endregion

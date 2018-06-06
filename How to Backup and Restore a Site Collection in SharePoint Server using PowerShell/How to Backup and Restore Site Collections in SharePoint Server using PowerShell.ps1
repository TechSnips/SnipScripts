<# Pre-requisites
    ** Make sure to have permissions on both databases Source & Destination (including permissions to run PowerShell cmdlets against them)
    ** Make sure to have permissions on the backup folder
#>

#Add SP snappin (if not in SP Mngt Shell)
Add-PSSnapin Microsoft.SharePoint.PowerShell

#Create the backup - ENTER YOUR OWN SITE COLLECTION URL and BACKUP PATH
Backup-SPSite -Identity "http://demo.pwsh.net/sites/techsnips" -Path "C:\SPBackups\techsnips.bak"

#region Restore Backup to another Web Application - ENTER YOUR OWN SITE COLLECTION URL + OWN DATABASE NAME
#! DO NOT create the destination Site Collection - Will be created during the "Restore" phase (Only Web Application path should be valid...)
Restore-SPSite -Identity "http://test.pwsh.net/sites/techsnipsrestored" -Path "C:\SPBackups\techsnips.bak" -DatabaseName "SP2016_TEST" -Confirm:$false
#endregion
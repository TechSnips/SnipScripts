#Connect to SharePoint site
Connect-PnPOnline -Url https://<TENANT-NAME>.sharepoint.com/sites/<SITE-NAME>

#Retrieve all the Lists and Libraries
Get-PnPList

#Check if 'Document ID' feature is enabled for the site collection
Get-PnPFeature -Scope Site

#Retrieve documents to move from SOURCE library
$allDocs = (Get-PnPListItem -List <LIBRARY-NAME>).FieldValues

#region MOVE documents to TARGET library
$targetLib = "<YOUR-TARGET-LIBRARY-PATH>"

foreach ($item in $allDocs) {
    Move-PnPFile -ServerRelativeUrl $item.FileRef -TargetUrl ($targetLib + $item.FileLeafRef) -Force
}
#endregion



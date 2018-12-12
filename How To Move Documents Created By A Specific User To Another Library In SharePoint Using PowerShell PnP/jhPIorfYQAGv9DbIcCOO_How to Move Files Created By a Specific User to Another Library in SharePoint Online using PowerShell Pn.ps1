#Connect to SharePoint site
Connect-PnPOnline -Url https://<TENANT-NAME>/sites/<SITE-NAME>

#Check if 'Document ID' feature is enabled for the site collection
Get-PnPFeature -Scope Site

#Retrieve documents to move from SOURCE library
$allDocs = (Get-PnPListItem -List <LIBRARY-NAME>).FieldValues 

#region MOVE documents to TARGET library
$targetLib = "<YOUR-TARGET-LIBRARY-PATH>"

foreach ($item in $allDocs) {
    if ($item.Created_x0020_By -like "*<YOUR-USER@<YOUR-DOMAIN>.com*") {
        Move-PnPFile -ServerRelativeUrl $item.FileRef -TargetUrl ($targetLib + $item.FileLeafRef) -Force
    }
}
#endregion



# SharePoint Patterns & Practices (aka PnP)
# Available on GitHub >> https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets?view=sharepoint-ps

#Connect to SharePoint Online
$creds = Get-Credential
Connect-PnPOnline -Url "https://<TENANT-NAME>.sharepoint.com/sites/techsnips" -Credentials $creds

#Retrieve Subsites in this Site Collection
Get-PnPSubWebs

#Retrieve all subsites + sub-subsites 
Get-PnPSubWebs -Recurse


#Retrieve sub-subsites for a particular subsite - ENTER YOUR OWN SITE COLLECTION RELATIVE URL 
Get-PnPSubWebs -Identity "/sites/techsnips/subsitea" -Recurse

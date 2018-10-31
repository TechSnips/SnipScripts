#########################################
## Change the cmdlet parameters to your scenario ##
 ########################################

#Connect to the SharePoint Admin Center
$creds = Get-Credential
Connect-PnPOnline -Url "https://<TENANT-NAME>-admin.sharepoint.com" -Credentials $creds

#Create the Modern Team Site without an O365 group
$NewModernTeamSite = @{
    Title        = "<YOUR TITLE>"
    Url          = "https://<TENANT-NAME>.sharepoint.com/sites/<YOUR_URL>"
    Owner        = "username@myDomain.com"
    Lcid         = 1033
    Template     = "STS#3"  # This is the template to use for Modern Team Site without O365 group!
    TimeZone     = 2  # This is for GMT - UK
    StorageQuota = 1024
}
New-PnPTenantSite @NewModernTeamSite

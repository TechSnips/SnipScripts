#Check if SharePoint Snapin loaded
    $SPSnapin = Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.SharePoint.PowerShell"}
    if (!($SPSnapin)) {
        Write-Warning -Message "SharePoint snapin not present. Trying to add it now..."
        Add-PSSnapin Microsoft.SharePoint.PowerShell
    }
    else {
        Write-Host "SharePoint snapin already loaded." -ForegroundColor Gray
    }

#Create a Site Collection - ENTER YOUR OWN SITE COLLECTION TO CREATE & PARAMETERS
New-SPSite -Url "<YOUR OWN SITE COLLECTION URL>" -Name "TechSnips Videos" -Template "STS#0" -OwnerAlias "<PRIMARY ADMIN>" -SecondaryOwnerAlias "<SECONDARY ADMIN>" -Description "Videos from TechSnips" -Language "1033" -Verbose

#Change Secondary Site Collection Admin
Set-SPSite -Identity "<YOUR OWN SITE COLLECTION URL>" -SecondaryOwnerAlias "<NEW SECONDARY ADMIN>" -Url "<NEW SITE COLLECTION URL>" -Verbose

#Delete a Site Collection
Remove-SPSite -Identity "<YOUR OWN SITE COLLECTION URL>" -GradualDelete -Confirm:$false -Verbose

#Confirm deletion
Get-SPSite -WebApplication "<YOUR OWN WEB APPLICATION URL>"


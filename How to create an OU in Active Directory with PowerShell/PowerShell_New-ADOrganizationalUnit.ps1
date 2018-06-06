#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
Set-ADOrganizationalUnit 'OU=Cool People,DC=TechSnipsDemo,DC=org' -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit 'OU=Cool People,DC=TechSnipsDemo,DC=org' -Confirm:$false
Set-ADOrganizationalUnit 'OU=Automatic Drivers,OU=People,DC=TechSnipsDemo,DC=org' -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit 'OU=Automatic Drivers,OU=People,DC=TechSnipsDemo,DC=org' -Confirm:$false
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

New-ADOrganizationalUnit -Name 'Cool People'

Get-ADOrganizationalUnit 'OU=Cool People,DC=TechSnipsDemo,DC=org'

#endregion

#region complex

$NewOU = @{
    'Name' = 'Automatic Drivers'
    'Description' = 'People that drive automatic cars'
    'Path' = 'OU=People,DC=TechSnipsDemo,DC=org'
    'ProtectedFromAccidentalDeletion' = $true
}
New-ADOrganizationalUnit @NewOU

Get-ADOrganizationalUnit 'OU=Automatic Drivers,OU=People,DC=TechSnipsDemo,DC=org'
#endregion
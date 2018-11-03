#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
New-ADOrganizationalUnit 'Zigerions'
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADOrganizationalUnit -Identity 'OU=Zigerions,DC=TechSnipsDemo,DC=org'

Set-ADOrganizationalUnit -Identity 'OU=Zigerions,DC=TechSnipsDemo,DC=org' -ProtectedFromAccidentalDeletion $false

Remove-ADOrganizationalUnit -Identity 'OU=Zigerions,DC=TechSnipsDemo,DC=org' -Confirm:$false

Get-ADOrganizationalUnit -Identity 'OU=Zigerions,DC=TechSnipsDemo,DC=org'

#endregion
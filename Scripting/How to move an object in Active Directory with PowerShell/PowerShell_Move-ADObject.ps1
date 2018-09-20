#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADUser 'Han Solo'
New-ADOrganizationalUnit 'Carbonite'
New-ADOrganizationalUnit 'Rebels'
#endregion
#region clean
Function Prompt(){}
$user = Get-ADUser 'Han Solo'
Move-ADObject $user.DistinguishedName -TargetPath 'OU=Carbonite,DC=TechSnipsDemo,DC=org'
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADUser -Identity 'Han Solo' | Select-Object Name,DistinguishedName

$user = Get-ADUser -Identity 'Han Solo'

Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=Rebels,DC=TechSnipsDemo,DC=org"

Get-ADUser -Identity 'Han Solo' | Select-Object Name,DistinguishedName

#endregion
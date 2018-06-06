#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
New-ADUser -Name 'Tyrone Rugen' -GivenName 'Tyrone' -Surname 'Rugen' -UserPrincipalName 'SixFingeredMan@TechSnipsDemo.org'
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADUser -Identity 'Tyrone Rugen'

Remove-ADUser -Identity 'Tyrone Rugen' -Confirm:$false

Get-ADUser -Identity 'Tyrone Rugen'

#endregion
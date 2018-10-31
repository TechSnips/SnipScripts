#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
Remove-ADGroup STF -Confirm:$false
Remove-ADGroup 'Star Wars Fans' -Confirm:$false
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

New-ADGroup -Name 'Star Wars Fans' -GroupScope Global

Get-ADGroup 'Star Wars Fans' | Select-Object Name,GroupScope,GroupCategory

#endregion

#region complex

$NewGroup = @{
    'Name' = 'Star Trek Fans'
    'GroupScope' = 'Universal'
    'GroupCategory' = 'Distribution'
    'Description' = 'Real Science Fiction'
    'SamAccountName' = 'STF'
}
New-ADGroup @NewGroup

$Properties = 'Name','GroupScope','GroupCategory','Description','SamAccountName'

Get-ADGroup -Identity 'STF' -Properties $Properties | Select-Object $Properties
#endregion
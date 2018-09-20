#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADGroup -Name 'Still in the Matrix' -GroupScope Universal
New-ADUser 'The Oracle'
New-ADComputer 'Agent Brown'
New-ADComputer 'Agent Jones'
New-ADComputer 'Agent Smith'
New-ADUser 'Rowan Witt'
New-ADUser 'Jeremy Ball'
New-ADUser 'Harry Lawrence'
New-ADUser 'Fiona Johnson'
New-ADUser 'The White Rabbit'
New-ADUser 'Thomas Anderson'
New-ADGroup 'Normal Folks' -GroupScope Global
Add-ADGroupMember 'Still in the Matrix' -Members 'Agent Smith$','The White Rabbit','Normal Folks','Thomas Anderson','Fiona Johnson','Harry Lawrence','Jeremy Ball','Rowan Witt','The Oracle','Agent Brown$','Agent Jones$','Rowan Witt'
#endregion
#region clean
Function Prompt(){}
Add-ADGroupMember 'Still in the Matrix' -Members 'Thomas Anderson','Agent Smith$'
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADGroupMember -Identity 'Still in the Matrix' | Select-Object Name,ObjectClass

Remove-ADGroupMember -Identity 'Still in the Matrix' -Members 'Thomas Anderson','Agent Smith$' -Confirm:$false

Get-ADGroupMember -Identity 'Still in the Matrix' | Select-Object Name,ObjectClass

#endregion
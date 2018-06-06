#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADGroup -Name 'Minions of Sauron' -GroupScope Universal
New-ADUser 'Saruman'
New-ADGroup 'Uruk-Hai' -GroupScope Global
New-ADComputer 'The Eye'
#endregion
#region clean
Function Prompt(){}
Get-ADGroupMember 'Minions of Sauron' | %{ Remove-ADGroupMember 'Minions of Sauron' -Members $_ -Confirm:$false}
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADUser -Identity 'Saruman'

Get-ADGroup -Identity 'Uruk-Hai'

Get-ADComputer -Identity 'The Eye'

Get-ADGroupMember -Identity 'Minions of Sauron'

Add-ADGroupMember -Identity 'Minions of Sauron' -Members 'Saruman','Uruk-Hai','The Eye$'

Get-ADGroupMember -Identity 'Minions of Sauron' | Select-Object Name

#endregion
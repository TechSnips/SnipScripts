#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
New-ADGroup -Name 'Loose Ends' -GroupScope Global
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADGroup -Identity 'Loose Ends'

Remove-ADGroup -Identity 'Loose Ends' -Confirm:$false

Get-ADGroup -Identity 'Loose Ends'

#endregion
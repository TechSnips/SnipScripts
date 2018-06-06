#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
New-ADComputer 'HAL 9000'
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADComputer -Identity 'HAL 9000'

Remove-ADComputer -Identity 'HAL 9000' -Confirm:$false

Get-ADComputer -Identity 'HAL 9000'

#endregion
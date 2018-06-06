#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADUser 'Malcolm Reynolds'
$password = ConvertTo-SecureString -AsPlainText 'Password1' -Force
Set-ADAccountPassword 'malcolm reynolds' -NewPassword $password
set-aduser 'malcolm reynolds' -Enabled $true
#endregion
#region clean
Function Prompt(){}
#get-aduser 'malcolm reynolds' -prop lockedout
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

Get-ADUser -Identity 'Malcolm Reynolds' -Properties LockedOut | Select-Object Name,Lockedout

Unlock-ADAccount -Identity 'Malcolm Reynolds'

Get-ADUser -Identity 'Malcolm Reynolds' -Properties LockedOut | Select-Object Name,Lockedout

#endregion
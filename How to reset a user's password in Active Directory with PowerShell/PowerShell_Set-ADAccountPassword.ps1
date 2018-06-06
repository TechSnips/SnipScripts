#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADUser 'Laura Roslin'
#endregion
#region clean
Function Prompt(){}
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

$password = ConvertTo-SecureString 'MySecurePassword1!' -AsPlainText -Force

Set-ADAccountPassword 'Laura Roslin' -Reset -NewPassword $password

Set-ADUser 'Laura Roslin' -ChangePasswordAtLogon $true

#endregion
#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Copying a user to create a new user
Get-ADUser 'Anthony Howell' -Properties Title,Department | Format-List Name,Title,Department

$user = Get-ADUser 'Anthony Howell' -Properties Title,Department

New-ADUser -Name 'Christopher Sholes' -Instance $user

Get-ADUser 'Christopher Sholes' -Properties Title,Department | Format-List Name,Title,Department
#endregion

#region Not all attributes copy
Get-ADUser 'Anthony Howell' -Properties MemberOf,PasswordLastSet | Format-List Name,MemberOf,PasswordLastSet

$user = Get-ADUser 'Anthony Howell' -Properties MemberOf #,PasswordLastSet

New-ADUser -Name 'Arthur Scherbius' -Instance $user

Get-ADUser 'Arthur Scherbius' -Properties MemberOf,PasswordLastSet | Format-List Name,MemberOf,PasswordLastSet

#endregion
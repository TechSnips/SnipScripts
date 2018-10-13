#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Creating new users

#region A simple example of New-ADUser
New-ADUser 'Anthony Howell'

Get-ADUser 'Anthony Howell'
#endregion

#region A more complex example of New-ADUser
$NewEngineer = @{
    'GivenName' = 'Douglas'
    'Surname' = 'Engelbart'
    'Name' = 'Douglas Engelbart'
    'DisplayName' = 'Douglas Engelbart'
    'SamAccountName' = 'Douglas.Engelbart'
    'UserPrincipalName' = 'Douglas.Engelbart@techsnips.local'
    'EmailAddress' = 'Douglas.Engelbart@techsnips.io'
    'Title' = 'Engineer'
    'Department' = 'Research and Development'
    'Country' = 'US'
    'Manager' = 'Anthony Howell'
    'AccountPassword' = (ConvertTo-SecureString 'SecurePassword1!' -AsPlainText -Force)
}
New-ADUser @NewEngineer

$Properties = 'GivenName','SurName','Name','DisplayName','SamAccountName', `
'UserPrincipalName','EmailAddress','Title','Department','Country','Manager'

# Using the -Properties parameter to specify which properties to return
Get-ADUser -Identity 'Douglas.Engelbart' -Properties $Properties | Select-Object $Properties
#endregion

#endregion

#region Getting

#region Filtering for all users
Get-ADUser -Filter * | Format-Table Name
#endregion

#region Filtering by a single attribute
Get-ADUser -Filter {Department -eq "IT"} -Properties Department | Format-Table Name,Department

Get-ADUser -Filter {Title -like "*Manager"} -Properties Title | Format-Table Name,Title
#endregion

#region Filtering by multiple attributes
$filter = {(Department -eq "IT") -and (Manager -eq "abertram")}
Get-ADUser -Filter $filter -Properties Department,Manager | Format-Table Name,Department,Manager
#endregion

#region Retrieving users by OU
$OUPath = 'OU=People,DC=techsnips,DC=local'
Get-ADUser -Filter * -SearchBase $OUPath | Format-Table Name
#endregion

#region Both a filter and OU
$userSplat = @{
    SearchBase = $OUPath
    Filter = $filter
    Properties = 'Department','Manager'
}
Get-ADUSer @userSplat | Format-Table Name,DistinguishedName,Department,Manager
#endregion

#endregion

#region Setting

#region Attributes with parameters
Get-ADUser 'Anthony Howell' -Properties Title,Department | Format-Table Name,Title,Department

Set-ADUser 'Anthony Howell' -Title 'Overlord' -Department 'Upper Echelon'

Get-ADUser 'Anthony Howell' -Properties Title,Department | Format-Table Name,Title,Department
#endregion

#region Attributes without parameters
Get-ADUser 'Anthony Howell' -Properties IPPhone

$user = Get-ADUser 'Anthony Howell' -Properties IPPhone
$user.IPPhone = 7647
Set-ADUser -Instance $user

Get-ADUser 'Anthony Howell' -Properties IPPhone
#endregion

#endregion

#region Removing

Get-ADUser 'GPOTest'

Remove-ADUser 'GPOTest' -Confirm:$false

Get-ADUser 'GPOTest'

#endregion
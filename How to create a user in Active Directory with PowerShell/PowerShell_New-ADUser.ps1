#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
New-ADOrganizationalUnit 'OU=Service Accounts,DC=TechSnipsDemo,DC=Org'
#endregion
#region clean
Function Prompt(){}
Remove-ADUser "Anthony Howell" -Confirm:$false
Remove-ADUser "Franz.Ferdinand" -Confirm:$false
Remove-ADUser 'sqlserver' -Confirm:$false
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

New-ADUser -Name 'Anthony Howell'

Get-ADUser 'Anthony Howell'

#endregion

#region complex
$NewExecutive = @{
    'GivenName' = 'Franz'
    'Surname' = 'Ferdinand'
    'Name' = 'Franz Ferdinand'
    'DisplayName' = 'Franz Ferdinand'
    'SamAccountName' = 'Franz.Ferdinand'
    'UserPrincipalName' = 'Franz.Ferdinand@techsnipsdemo.org'
    'EmailAddress' = 'Franz.Ferdinand@techsnipsdemo.org'
    'Title' = 'Archduke'
    'Department' = 'Executives'
    'Country' = 'AT'
    'Manager' = 'Anthony Howell'
    'AccountPassword' = (ConvertTo-SecureString 'SecurePassword1!' -AsPlainText -Force)
}
New-ADUser @NewExecutive

$Properties = 'GivenName','SurName','Name','DisplayName','SamAccountName','UserPrincipalName','EmailAddress','Title','Department','Country','Manager'

Get-ADUser -Identity Franz.Ferdinand -Properties $Properties | Select-Object $Properties

#region service account

$NewServiceAccount = @{
    'Name' = 'SQL Service Account'
    'SamAccountName' = 'sqlserver'
    'UserPrincipalName' = 'sqlserver@techsnipsdemo.org'
    'CannotChangePassword' = $true
    'PasswordNeverExpires' = $true
    'AccountPassword' = (ConvertTo-SecureString 'fqp7FY7NDJsdkjBC' -AsPlainText -Force)
    'AccountExpirationDate' = (Get-Date '11/05/2050')
    'Path' = 'OU=Service Accounts,DC=TechSnipsDemo,DC=Org'
    'LogonWorkstations' = 'SQL01-Prod,SQL02-Prod'
    'OtherAttributes' = @{'Type' = 'ServiceAccount'}
}
New-ADUser @NewServiceAccount

$Properties = 'Name','SamAccountName','UserPrincipalName','CannotChangePassword','PasswordNeverExpires','AccountExpirationDate','DistinguishedName','LogonWorkstations','Type'

Get-ADUser -Identity 'sqlserver' -Properties $Properties | Select-Object $Properties
#endregion
#endregion
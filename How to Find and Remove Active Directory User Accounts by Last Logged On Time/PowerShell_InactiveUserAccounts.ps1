#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Search-ADAccount

#By time span
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00'
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00' | Format-Table Name,LastLogonDate

Search-ADAccount -AccountInactive -TimeSpan (New-TimeSpan -Days 30) | Format-Table Name,LastLogonDate

#By date
Search-ADAccount -AccountInactive -DateTime "08/10/2018 00:00:00" | Format-Table Name,LastLogonDate

Search-ADAccount -AccountInactive -DateTime (Get-Date).AddDays(-30) | Format-Table Name,LastLogonDate

#Removing the users
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00' -UsersOnly |`
Remove-ADUser -WhatIf

#endregion

#region Avoiding newly created accounts

#problem
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00' -UsersOnly |`
ForEach-Object {Get-ADUser -Identity $_ -Properties Created} |`
Select-Object @{
    Name="Name";Expression={$_.Name}
},@{
    Name="Created";Expression={New-TimeSpan -Start $_.Created -End (Get-Date)}}

#Using search base
Search-ADAccount -AccountInactive -DateTime (Get-Date).AddDays(-10) -SearchBase 'OU=IT,OU=People,DC=techsnips,DC=local'

#Or using Get-ADUser -filter
#LastLogonTimeStamp info: https://blogs.technet.microsoft.com/askds/2009/04/15/the-lastlogontimestamp-attribute-what-it-was-designed-for-and-how-it-works/
$logonDate = (Get-Date).AddDays(-90).ToFileTime()
$createdDate = (Get-Date).AddDays(-14).ToFileTime()
Get-ADUser -Filter {LastLogonDateTimeStamp -lt $logonDate}
Get-ADUser -Filter {LastLogonDateTimeStamp -notlike "*"}
Get-ADUser -Filter {Created -lt $createdDate}

#All together
$filter = {
    ((LastLogonTimeStamp -lt $logonDate) -or (LastLogonTimeStamp -notlike "*"))
    -and (Created -lt $createdDate)
}

Get-ADUser -Filter $filter | Remove-ADUser -WhatIf

#endregion
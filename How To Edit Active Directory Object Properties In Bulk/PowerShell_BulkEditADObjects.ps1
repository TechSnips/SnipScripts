#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt{}
Clear-Host
#endregion

#region notes
#OUs
$OUPath = 'OU=People,DC=techsnips,DC=local'
'Chiefs','Minions' | %{New-ADOrganizationalUnit $_ -Path $OUPath}

#users
'Roy','Maurice','Jen','Richmond' | %{New-ADUser $_ -Department 'IT' -Company 'Reynholm Industries' -UserPrincipalName "$_`@techsnips.local"}
'Roy','Maurice' | %{Set-ADUser $_ -Title 'Service Desk Tech'}
'Douglas Reynholm','Denholm Reynholm' | %{New-ADUser $_ -Department 'Chiefs' -Company 'Reynholm Industries' -UserPrincipalName "$_`@techsnips.local"}
Set-ADuser 'Jen' -Title 'Relationship Manager'
'Douglas Reynholm','Denholm Reynholm' | %{Set-ADUser $_ -Title 'Chief Executive Officer'}
'Douglas Reynholm','Denholm Reynholm' | %{Set-ADAccountPassword $_ -Reset -NewPassword (ConvertTo-SecureString 'Something!Long@And#Random$' -AsPlainText -Force)}
'Roy','Maurice','Richmond' | %{Set-ADUser $_ -Manager 'Jen'}
'Roy','Maurice','Jen','Richmond' | %{Move-ADObject (Get-ADUser $_).DistinguishedName -TargetPath "OU=Minions,$OUPath"}
'Douglas Reynholm','Denholm Reynholm' | %{Move-ADObject (Get-ADUser $_).DistinguishedName -TargetPath "OU=Chiefs,$OUPath"}
'Roy','Maurice','Jen','Richmond','Douglas Reynholm' | %{Set-ADUser $_ -Enabled $true}

#groups
'IT Department','Chiefs Department','Service Desk' | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}

#clean
'Roy','Maurice','Jen','Richmond','Douglas Reynholm','Denholm Reynholm' | %{Remove-ADUser $_ -Confirm:$false}
'IT Department','Chiefs Department','Service Desk' | %{Remove-ADGroup $_ -Confirm:$false}
"OU=Chiefs,$OUPath","OU=Minions,$OUPath" | %{Set-ADOrganizationalUnit $_ -ProtectedFromAccidentalDeletion $False}
"OU=Chiefs,$OUPath","OU=Minions,$OUPath" | %{Remove-ADOrganizationalUnit $_ -Confirm:$false}
#endregion

#region Selecting users
#Filtering for all users
Get-ADUser -Filter * | Format-Table Name


#Filtering by a single attribute
Get-ADUser -Filter {Department -eq "IT"} | Format-Table Name

Get-ADUser -Filter {Title -like "*Manager"} | Format-Table Name


#Filtering by multiple attributes
Get-ADUser -Filter {(Department -eq "IT") -and (Manager -eq "Jen")} | Format-Table Name

$before = (Get-Date).AddDays(-2)
$after = (Get-Date).AddDays(-6)
Get-ADUser -Filter {(Created -gt $after) -and (Created -lt $before)} | Format-Table Name


#Retrieving users by OU
$OUPath = 'OU=People,DC=techsnips,DC=local'
Get-ADUser -Filter * -SearchBase $OUPath | Format-Table Name


#Both
Get-ADUSer -SearchBase $OUPath -Filter {(Enabled -eq $true) -and (PasswordExpired -eq $false)} | Format-Table Name

#endregion

#region Bulk update examples

#Update UserPrincipalName (i.e. for O365)
#Pipeline, ForEach-Object
Get-ADUser -SearchBase $OUPath -Filter {UserPrincipalName -notlike "*techsnips.io"} | Format-Table Name,UserPrincipalName

Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"} | `
%{Set-ADUser $_ -UserPrincipalName "$($_.SamAccountName)`@techsnips.io"}

Get-ADUser -SearchBase $OUPath -Filter {UserPrincipalName -notlike "*techsnips.io"} | Format-Table Name,UserPrincipalName


#Foreach
ForEach($user in Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"}){
    Set-ADUser -Identity $user -UserPrincipalName "$($user.SamAccountName)`@techsnips.io"
}


#Reset password expiration date for C Levels
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Chiefs,$OUPath" -Properties PasswordLastSet | Format-Table Name,PasswordLastSet

ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Chiefs,$OUPath"){
    $user.pwdlastset = 0
    Set-ADUser -Instance $user
    $user.pwdlastset = -1
    Set-ADUser -Instance $user
}
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Chiefs,$OUPath" -Properties PasswordLastSet | Format-Table Name,PasswordLastSet


#Add users by title into groups
Get-ADGroupMember 'Service Desk' | Format-Table Name

ForEach($user in Get-ADUser -Filter {Title -eq 'Service Desk Tech'}){
    Write-Host "Adding $($user.name) to group: Service Desk"
    Add-ADGroupMember 'Service Desk' -Members $user.SamAccountName
}
Get-ADGroupMember 'Service Desk' | Format-Table Name


#Make sure each user is a member of their department group
#$user.Department = Human Resources
#Group = Human Resources Department

Get-ADGroupMember 'IT Department' | Format-Table Name
Get-ADGroupMember 'Chiefs Department' | Format-Table Name

$user = Get-ADUser -Identity 'Roy' -Properties MemberOf
$user.MemberOf
$user.MemberOf -Replace '(CN=)*(,.*)*'

ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase $OUPath -Properties Department,MemberOf){
    If($user.MemberOf -replace '(CN=)*(,.*)*' -notcontains "$($user.Department) Department"){
        Write-Host "Adding $($user.name) to group: $($user.Department) Department"
        Add-ADGroupMember "$($user.Department) Department" -Members $user.SamAccountName
    }
}

Get-ADGroupMember 'IT Department' | Format-Table Name
Get-ADGroupMember 'Chiefs Department' | Format-Table Name
#endregion
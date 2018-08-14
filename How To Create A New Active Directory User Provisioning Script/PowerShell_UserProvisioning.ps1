#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Basic
#Known values
$domain = (Get-ADDomain).DNSRoot
$emailDomain = 'techsnips.io'
$company = 'TechSnips'
$usersOU = 'OU=People,dc=techsnips,dc=local'

#Prompt for needed information
$fname = Read-Host -Prompt 'Please enter the first name of the new user'
$lname = Read-Host -Prompt 'Please enter the last name of the new user'
$username = "$($fname[0])$lname"

#create the user
$NewUserSplat = @{
    Name = "$fname $lname"
    GivenName = $fname
    SurName = $lname
    SamAccountName = $username
    UserPrincipalName = "$username`@$domain"
    EmailAddress = "$username`@$emailDomain"
    Company = $company
}
New-ADUser @NewUserSplat

Get-ADUser -Identity $username -Properties EmailAddress,Company

#endregion

#region Adding other attributes
#Simple title
$title = Read-Host "Enter in $fname's title"
Set-ADUser -Identity $username -Title $title

Get-ADuser -Identity $username -Properties Title | Format-Table Name,Title

#IPPhone, a property not settable with an explicit parameter in Set-ADUser
$ipPhone = Read-Host "Enter in $fname's extension"
$tmpUser = Get-ADUser $username
$tmpUser.IPPhone = $ipPhone
Set-ADUser -Instance $tmpUser

Get-ADuser -Identity $username -Properties IPPhone | Format-Table Name,IPPhone

#Departments with template
$validDepartmentNames = 'Accounting','Human Resources','Sales','Information Technology'
#Build an object with indexes
$validDepartments = @()
For($x=0;$x -lt $validDepartmentNames.count;$x++){
    $validDepartments += [PSCustomObject]@{
        Index = $x
        Department = $validDepartmentNames[$x]
    }
}
$validDepartments | Format-Table -HideTableHeaders
#Prompt
$departmentIndex = Read-Host "Enter in $fname's department number"
Set-ADUser -Identity $username -Department $validDepartmentNames[$departmentIndex]

Get-ADuser -Identity $username -Properties Department | Format-Table Name,Department

#Input validation for a phone number
$validNumber = $false
While(!$validNumber){
    $mobile = Read-Host "Enter in $fname's mobile number"
    If($mobile -match "\d{3}-\d{3}-\d{4}"){ #looking for: xxx-xxx-xxxx
        Set-ADUser -Identity $username -MobilePhone $mobile
        $validNumber = $true
    }Else{
        Write-Host 'Expected format: xxx-xxx-xxxx'
    }
}

Get-ADuser -Identity $username -Properties MobilePHone | Format-Table Name,MobilePhone

#validating a manager
$managerName = $null
While(!$managerName){
	$managerName = Read-Host "`nPlease enter the username of $fname's manager"
	Try{
        $manager = Get-ADUser $managerName
        Set-ADUser -Identity $username -Manager $managerName
	}Catch{
		Write-Host "$managerName does not exist."
		$managerName = $null
	}
}

Get-ADUser -Identity $username -Properties Manager | Format-Table Name,Manager

#endregion

#region Username validation

#from before
$username

#validation
$exists = $true
$letterCount = 1
While($exists){
    Try{
        $newusername = $($fname.substring(0,$letterCount)) + $lname
        $user = Get-ADUser $newusername
        Write-Host "Username: $newusername already exists, trying another..."
        $letterCount++
    }Catch{
        $exists = $false
    }
}
Write-Host "Using: $newusername"

#endregion

#region Copying group memberships

$templateUser = $null
While(!$templateUser){
    #Prompt for the user to copy from
	$templateUserName = Read-Host "Please enter the template user"
	Try{
        #Validate they exist
        $templateUser = Get-ADUser $templateUserName -Properties MemberOf
        #Add new user to each group
        ForEach($group in $templateUser.MemberOf){
            Write-Host "Adding user to $group..."
            Add-ADGroupMember -Identity $group -Members $username 
        }
    }Catch{
		Write-Host "Unable to find $templateUserName..."
	}
}

Get-ADUser -Identity $username -Properties MemberOf | Format-List Name,Memberof
#endregion

#region Putting the user in the correct OU
#By department
$user = Get-ADUser $username -Properties Department
Switch($user.Department){
    'Accounting' {$targetOU = 'ACT'}
    'Human Resources' {$targetOU = 'HR'}
    'Sales' {$targetOU = 'SLS'}
    'Information Technology' {$targetOU = 'IT'}
    default {$targetOU = 'NEW'}
}
Move-ADObject $user.DistinguishedName -TargetPath "OU=$targetOU,$usersOU"

Get-ADUser -Identity $username | Format-Table DistinguishedName

#By selection
$OUs = (Get-ChildItem AD:\"$UsersOU" | Where-Object ObjectClass -eq 'organizationalUnit').Name
$x = 0
ForEach($OU in $OUs){
    Write-Host " $x  $OU"
    $x++
}
$OUIndex = -1
While($OUIndex -lt 0 -or $OUIndex -ge $x){
    $OUIndex = Read-Host "Enter in the target OU's index"
    Move-ADObject (Get-ADUser $username).DistinguishedName -TargetPath "OU=$($OUs[$OUIndex]),$usersOU"
}

Get-ADUser -Identity $username | Format-Table DistinguishedName
#endregion

#region setting the password
[char[]]$chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*<>/?=+\-_'
$validPassword = $false
While(!$validPassword){
    $password = ($chars | Get-Random -count 10) -join ""
    Try{
        Set-ADAccountPassword $username -NewPassword ($password | ConvertTo-SecureString -AsPlainText -Force)
        Set-ADUser $username -Enabled $true
		$validPassword = $true
    }Catch{}
}
Write-Host "Password: $password"
#endregion

#region Final Script

#Known values
$domain = (Get-ADDomain).DNSRoot
$emailDomain = 'techsnips.io'
$company = 'TechSnips'
$usersOU = 'OU=People,dc=techsnips,dc=local'

#Prompt for needed information
$fname = Read-Host -Prompt 'Please enter the first name of the new user'
$lname = Read-Host -Prompt 'Please enter the last name of the new user'
$username = "$($fname[0])$lname"

#create and validate the user
$exists = $true
$letterCount = 1
While($exists){
    Try{
        $username = $($fname.substring(0,$letterCount)) + $lname
        $user = $null
        $user = Get-ADUser $username
        Write-Host "Username: $username already exists, trying another..."
        $letterCount++
    }Catch{
        $exists = $false
    }
}
Write-Host "Using: $username"

$NewUserSplat = @{
    Name = "$fname $lname"
    GivenName = $fname
    SurName = $lname
    SamAccountName = $username
    UserPrincipalName = "$username`@$domain"
    EmailAddress = "$username`@$emailDomain"
    Company = $company
}
New-ADUser @NewUserSplat

#Simple title
$title = Read-Host "Enter in $fname's title"
Set-ADUser -Identity $username -Title $title

#IPPhone, a property not settable with an explicit parameter in Set-ADUser
$ipPhone = Read-Host "Enter in $fname's extension"
$tmpUser = Get-ADUser $username
$tmpUser.IPPhone = $ipPhone
Set-ADUser -Instance $tmpUser

$templateUser = $null
While(!$templateUser){
    #Prompt for the user to copy from
	$templateUserName = Read-Host "Please enter the template user to copy groups from"
	Try{
        #Validate they exist
        $templateUser = Get-ADUser $templateUserName -Properties MemberOf
        #Add new user to each group
        ForEach($group in $templateUser.MemberOf){
            Write-Host "Adding user to $group..."
            Add-ADGroupMember -Identity $group -Members $username 
        }
    }Catch{
		Write-Host "Unable to find $templateUserName..."
	}
}

#set the manager
$managerName = $null
While(!$managerName){
	$managerName = Read-Host "`nPlease enter the username of $fname's manager"
	Try{
        $manager = Get-ADUser $managerName
        Set-ADUser -Identity $username -Manager $managerName
	}Catch{
		Write-Host "$manager does not exist."
		$managerName = $null
	}
}

#Departments with template
$validDepartmentNames = 'Accounting','Human Resources','Sales','Information Technology'
$validDepartments = @()
For($x=0;$x -lt $validDepartmentNames.count;$x++){
    $validDepartments += [PSCustomObject]@{
        Index = $x
        Department = $validDepartmentNames[$x]
    }
}
$validDepartments | Format-Table -HideTableHeaders
$departmentIndex = Read-Host "Enter in $fname's department number"
Set-ADUser -Identity $username -Department $validDepartmentNames[$departmentIndex]

#Input validation for a phone number
$validNumber = $false
While(!$validNumber){
    $mobile = Read-Host "Enter in $fname's mobile number"
    If($mobile -match "\d{3}-\d{3}-\d{4}"){ #looking for: xxx-xxx-xxxx
        Set-ADUser -Identity $username -MobilePhone $mobile
        $validNumber = $true
    }Else{
        Write-Host 'Expected format: xxx-xxx-xxxx'
    }
}

#Move to proper OU
$user = Get-ADUser $username -Properties Department
Switch($user.Department){
    'Accounting' {$targetOU = 'ACT'}
    'Human Resources' {$targetOU = 'HR'}
    'Sales' {$targetOU = 'SLS'}
    'Information Technology' {$targetOU = 'IT'}
    default {$targetOU = 'NEW'}
}
Move-ADObject $user.DistinguishedName -TargetPath "OU=$targetOU,$usersOU"

#set the password
[char[]]$chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*<>/?=+\-_'
$validPassword = $false
While(!$validPassword){
    $password = ($chars | Get-Random -count 10) -join ""
    Try{
        Set-ADAccountPassword -Identity $username -Reset -NewPassword ($password | ConvertTo-SecureString -AsPlainText -Force)
        Set-ADUser $username -Enabled $true
		$validPassword = $true
    }Catch{}
}
Write-Host "Password: $password"

#endregion

#region Validation

Get-ADUser $username -Properties Title,Department,Manager,IPPhone,MobilePhone,MemberOf

#endregion
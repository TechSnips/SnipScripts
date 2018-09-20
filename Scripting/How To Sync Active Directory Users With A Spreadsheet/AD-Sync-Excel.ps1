<<<<<<< HEAD
﻿#Requires -Modules ImportExcel
function Sync-StaffChanges {
    [CmdletBinding()]
    Param (
        [String] $Path,
        [String] $BaseOU = 'OU=users,OU=techsnips,DC=techsnips-test,DC=local',
        [String] $Company = 'TechSnips'
    )

    Import-Module -Name ImportExcel
    
    $ExcelData = Import-Excel -Path $Path -StartRow 2 -DataOnly
    
	foreach ($Staff in $ExcelData) {
        $EmployeeCode = $Staff.'Employee Code'.ToString()
        $ExistingUser = Get-ADUser -Filter {EmployeeID -eq $EmployeeCode}
        $Manager = Get-ADUser -Identity $Staff.'Managers User ID'
    
        if ($ExistingUser) {
            Write-Verbose -Message "$EmployeeCode found, updating user"

            $OU = 'OU={0},{1}' -f $Staff.Department, $BaseOU
    
            $ExistingUser.Description = $Staff.'Position Title'
            $ExistingUser.Title       = $Staff.'Position Title'
            $ExistingUser.Department  = $Staff.Department
            $ExistingUser.Manager     = $Manager.DistinguishedName
    
            if ($Staff.'End Date') {
                Write-Verbose -Message "Adding termination date for $EmployeeCode"
                $ExistingUser.AccountExpirationDate = $Staff.'End Date'
            } else {
                $ExistingUser.AccountExpirationDate = $null
            }
    
            Set-ADUser -Instance $ExistingUser
    
            if ($ExistingUser.DistinguishedName -notlike "*$OU") {
                Write-Verbose -Message "$EmployeeCode in incorrect OU, moving user"
                Move-ADObject -Identity $ExistingUser.DistinguishedName -TargetPath $OU
            }
        } else {
            Write-Verbose -Message "$EmployeeCode not found, creating user"
            $OU = 'OU={0},{1}' -f $Staff.Department, $BaseOU
            $Email = '{0}@techsnips.io' -f $Staff.'User ID'
            $UPN = '{0}@techsnips-test.local' -f $Staff.'User ID'
            $FullName = '{0} {1}' -f $Staff.'First Name', $Staff.'Last Name'

            $Password = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force
    
            $Params = @{
                Name              = $FullName
                DisplayName       = $FullName
                SamAccountName    = $Staff.'User ID'
                EmployeeID        = $EmployeeCode
                GivenName         = $Staff.'First Name'
                Surname           = $Staff.'Last Name'
                Description       = $Staff.'Position Title'
                Title             = $Staff.'Position Title'
                Department        = $Staff.Department
                Company           = $Company
                Path              = $OU
                EmailAddress      = $Email
                UserPrincipalName = $UPN
                AccountPassword   = $Password
                Enabled           = $true
            }
    
            if ($Staff.'End Date') {
                $Params.Add('AccountExpirationDate', $Staff.'End Date')
            }
    
            New-ADUser @Params
        }
    }
}
=======
#Requires -Modules ImportExcel
function Sync-StaffChanges {
    [CmdletBinding()]
    Param (
        [String] $Path,
        [String] $BaseOU = 'OU=users,OU=techsnips,DC=techsnips-test,DC=local',
        [String] $Company = 'TechSnips'
    )

    Import-Module -Name ImportExcel
    
    $ExcelData = Import-Excel -Path $Path -StartRow 2 -DataOnly
    
	foreach ($Staff in $ExcelData) {
        $EmployeeCode = $Staff.'Employee Code'.ToString()
        $ExistingUser = Get-ADUser -Filter {EmployeeID -eq $EmployeeCode}
        $Manager = Get-ADUser -Identity $Staff.'Managers User ID'
    
        if ($ExistingUser) {
            Write-Verbose -Message "$EmployeeCode found, updating user"

            $OU = 'OU={0},{1}' -f $Staff.Department, $BaseOU
    
            $ExistingUser.Description = $Staff.'Position Title'
            $ExistingUser.Title       = $Staff.'Position Title'
            $ExistingUser.Department  = $Staff.Department
            $ExistingUser.Manager     = $Manager.DistinguishedName
    
            if ($Staff.'End Date') {
                Write-Verbose -Message "Adding termination date for $EmployeeCode"
                $ExistingUser.AccountExpirationDate = $Staff.'End Date'
            } else {
                $ExistingUser.AccountExpirationDate = $null
            }
    
            Set-ADUser -Instance $ExistingUser
    
            if ($ExistingUser.DistinguishedName -notlike "*$OU") {
                Write-Verbose -Message "$EmployeeCode in incorrect OU, moving user"
                Move-ADObject -Identity $ExistingUser.DistinguishedName -TargetPath $OU
            }
        } else {
            Write-Verbose -Message "$EmployeeCode not found, creating user"
            $OU = 'OU={0},{1}' -f $Staff.Department, $BaseOU
            $Email = '{0}@techsnips.io' -f $Staff.'User ID'
            $UPN = '{0}@techsnips-test.local' -f $Staff.'User ID'
            $FullName = '{0} {1}' -f $Staff.'First Name', $Staff.'Last Name'

            $Password = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force
    
            $Params = @{
                Name              = $FullName
                DisplayName       = $FullName
                SamAccountName    = $Staff.'User ID'
                EmployeeID        = $EmployeeCode
                GivenName         = $Staff.'First Name'
                Surname           = $Staff.'Last Name'
                Description       = $Staff.'Position Title'
                Title             = $Staff.'Position Title'
                Department        = $Staff.Department
                Company           = $Company
                Path              = $OU
                EmailAddress      = $Email
                UserPrincipalName = $UPN
                AccountPassword   = $Password
                Enabled           = $true
            }
    
            if ($Staff.'End Date') {
                $Params.Add('AccountExpirationDate', $Staff.'End Date')
            }
    
            New-ADUser @Params
        }
    }
}
>>>>>>> f873d70360c2373cbbbb493a70df58b41a8ca9d0

<#
    Equivalents to the Group Policy Settings
        ComplexityEnabled = Passwords must meet complexity requirements
        MaxPasswordAge = Maximum password age
        MinPasswordAge = Minimum password age
        MinPasswordLength = Minimum password length
        PasswordHistoryCount = Enforce password history
        ReversibleEncryptionEnabled = Store passwords using reversible encryption
#>

#View the current domain password policy
Get-ADDefaultDomainPasswordPolicy

#Set the account lockout settings
$PasswordPolicy = @{
    Identity = 'techsnips.local'
    ComplexityEnabled = $true
    MinPasswordLength = 8
    MinPasswordAge = "5.00:00:00"
    MaxPasswordAge = "90.00:00:00"
    PasswordHistoryCount = 12
}

Set-ADDefaultDomainPasswordPolicy @PasswordPolicy
Get-ADDefaultDomainPasswordPolicy

#Change a single setting
Set-ADDefaultDomainPasswordPolicy -Identity "techsnips.local" -MinPasswordAge "1.00:00:00"
Get-ADDefaultDomainPasswordPolicy
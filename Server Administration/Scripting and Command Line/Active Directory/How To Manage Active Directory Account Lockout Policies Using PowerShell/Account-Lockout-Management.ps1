<#
    Equivalents to the Group Policy Settings
        LockoutDuration = Account lockout duration
        LockoutThreshold = Account lockout threshold
        LockoutObservationWindow = Reset account lockout counter after
#>

#View the current Account Lockout Policy
Get-ADDefaultDomainPasswordPolicy
Get-ADDefaultDomainPasswordPolicy | Select-Object -Property "Lockout*" | Format-List

#Set the account lockout settings
#The LockoutObservationWindow must be less than or equal to the LockoutDuration
$Lockout = @{
    Identity = 'techsnips.local'
    LockoutThreshold = 4
    LockoutObservationWindow = '00:45:00'
    LockoutDuration = '02:00:00'
}

Set-ADDefaultDomainPasswordPolicy @Lockout

#View the results
Get-ADDefaultDomainPasswordPolicy | Select-Object -Property "Lockout*" | Format-List
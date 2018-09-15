#View the default domain policy
Get-ADDefaultDomainPasswordPolicy

#Manufacturing PSO
New-ADFineGrainedPasswordPolicy -Name "Manufacturing" -Precedence 20 -MaxPasswordAge "180.00:00:00" -MinPasswordLength 8 `
-PasswordHistoryCount 12 -ComplexityEnabled $false -ReversibleEncryptionEnabled $false -ProtectedFromAccidentalDeletion $true

Add-ADFineGrainedPasswordPolicySubject -Identity "Manufacturing" -Subjects "CN=Manufacturing,OU=Manufacturing,OU=HQ,DC=corp,DC=ad"

#Human Resources PSO
New-ADFineGrainedPasswordPolicy -Name "Human Resources" -Precedence 10 -MaxPasswordAge "90.0:0:0" -MinPasswordLength 10 `
-LockoutDuration "0.01:00:00" -LockoutThreshold 5 -LockoutObservationWindow "0.00:30:00" `
-ReversibleEncryptionEnabled $false -ProtectedFromAccidentalDeletion $true

Add-ADFineGrainedPasswordPolicySubject -Identity "Human Resources" -Subjects "CN=Human Resources,OU=Human Resources,OU=HQ,DC=corp,DC=ad"

#Director of HR PSO
New-ADFineGrainedPasswordPolicy -Name "Director of Human Resources" -Precedence 15 -MaxPasswordAge "60.00:00:00" -MinPasswordAge "7.00:00:00" `
-MinPasswordLength 10 -LockoutDuration "1.00:00:00" -LockoutThreshold 5 -LockoutObservationWindow "0.01:00:00" `
-ReversibleEncryptionEnabled $false -ProtectedFromAccidentalDeletion $true

Add-ADFineGrainedPasswordPolicySubject -Identity "Director of Human Resources" -Subjects "CN=Stacey Andrews,OU=Human Resources,OU=HQ,DC=corp,DC=ad"

#View all PSOs
Get-ADFineGrainedPasswordPolicy -Filter *

#View a specific PSO
Get-ADFineGrainedPasswordPolicy -Identity "Manufacturing"

#View users and groups that PSO applies to
Get-ADFineGrainedPasswordPolicySubject -Identity "Human Resources"

#View resultant password policy for a user
Get-ADUserResultantPasswordPolicy -Identity stacey.andrews
Get-ADUserResultantPasswordPolicy -Identity cecil.oritz

#Add a group to an existing PSO
Add-ADFineGrainedPasswordPolicySubject -Identity "Human Resources" -Subjects "CN=IT,OU=IT,OU=HQ,DC=corp,DC=ad"
Get-ADFineGrainedPasswordPolicySubject -Identity "Human Resources"

#Removing a group from an existing PSO
Remove-ADFineGrainedPasswordPolicySubject -Identity "Human Resources" -Subjects "CN=IT,OU=IT,OU=HQ,DC=corp,DC=ad"
Get-ADFineGrainedPasswordPolicySubject -Identity "Human Resources"

#Remove a PSO
Remove-ADFineGrainedPasswordPolicy -Identity "Manufacturing"
Set-ADFineGrainedPasswordPolicy -Identity "Manufacturing" -ProtectedFromAccidentalDeletion $false
Get-ADFineGrainedPasswordPolicy -Filter *

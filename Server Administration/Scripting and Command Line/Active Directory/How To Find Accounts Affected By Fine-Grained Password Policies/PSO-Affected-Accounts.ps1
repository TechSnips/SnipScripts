#View all PSOs
Get-ADFineGrainedPasswordPolicy -Filter *
Get-ADFineGrainedPasswordPolicy -Filter * | Select-Object Name,AppliesTo

#View a specific PSO
Get-ADFineGrainedPasswordPolicy -Identity "Manufacturing"

#View users and groups that PSO applies to
Get-ADFineGrainedPasswordPolicySubject -Identity "Human Resources"

#View resultant password policy for a user
Get-ADUserResultantPasswordPolicy -Identity stacey.andrews
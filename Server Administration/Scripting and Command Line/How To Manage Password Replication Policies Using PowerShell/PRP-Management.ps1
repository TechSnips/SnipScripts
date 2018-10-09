#region Get PRP

#Get list of allowed accounts from the RODC
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Allowed

#Get list of denied accounts from the RODC
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Denied
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Denied | Select-Object -Property Name,ObjectClass

#Get list of allowed accounts from all RODCs
Get-ADDomainController -Filter {IsReadOnly -eq $true} | Get-ADDomainControllerPasswordReplicationPolicy -Allowed

#Get a list on group members for the Allowed and Denied RODC groups
Get-ADGroupMember -Identity "Allowed RODC Password Replication Group"
Get-ADGroupMember -Identity "Denied RODC Password Replication Group" | Select-Object -Property Name,ObjectClass

#endregion

#region Add PRP

#Add two groups and one user
Add-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -AllowedList "Manufacturing","Finance","Cecil.Oritz"
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Allowed | Select-Object -Property Name,ObjectClass

#Deny the HR group access to have thier passwords cached
Add-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -DeniedList "Human_Resources"
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Denied | Select-Object -Property Name,ObjectClass

#endregion

#region Remove PRP

#Remove the Finance group from the PRP as they are moving out of the branch office
Remove-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -AllowedList "Finance"
Get-ADDomainControllerPasswordReplicationPolicy -Identity "PROD-RODC" -Allowed | Select-Object -Property Name,ObjectClass

#endregion

#region Authenticated and Revealed PRP

#Get a list of all accounts that have been authenticated by this RODC
Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity "PROD-RODC" -AuthenticatedAccounts | Select-Object -Property Name,ObjectClass

#Get a list of users whose passwords are cached on this RODC
Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity "PROD-RODC" -RevealedAccounts | Select-Object -Property Name,ObjectClass

#Compare the two lists to discover authenticated users whose passwords aren't cached
$Auth = Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity "PROD-RODC" -AuthenticatedAccounts
$Revealed = Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity "PROD-RODC" -RevealedAccounts
Compare-Object -ReferenceObject $Auth -DifferenceObject $Revealed | Where-Object -Property SideIndicator -EQ "<="

#endregion

#region Prepopulate user password

Get-ADUser -Identity "Cecil.Oritz" | Sync-ADObject -Destination PROD-RODC -PasswordOnly
Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity "PROD-RODC" -RevealedAccounts | Select-Object -Property Name,ObjectClass

#endregion

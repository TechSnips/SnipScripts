#Verify the existing OU location of PROD-RODC
Get-ADComputer -SearchBase "DC=techsnips,DC=local" -Filter 'Name -eq "PROD-RODC"' | Select-Object -Property DistinguishedName

#Enter PS Session to PROD-RODC
Enter-PSSession -ComputerName PROD-RODC

#Check for domain membership and role
Get-ComputerInfo -Property csDomain,csDomainRole

#Install the Active Directory Domain Services Role
Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

#Install the RODC in Active Directory
Install-ADDSDomainController -DomainName "techsnips.local" -InstallDns:$true -ReadOnlyReplica:$true `
-SiteName Default-First-Site-Name -Credential (Get-Credential -Credential techsnips@techsnips.local)

#Re-enter PS Session to PROD-RODC
Enter-PSSession -ComputerName PROD-RODC

#Verify change to domain role
Get-ComputerInfo -Property csDomain,csDomainRole

#Exit remote PS Session
Exit-PSSession

#Verify computer account move to the "Domain Controllers" OU
Get-ADComputer -SearchBase "DC=techsnips,DC=local" -Filter 'Name -eq "PROD-RODC"' | Select-Object -Property DistinguishedName

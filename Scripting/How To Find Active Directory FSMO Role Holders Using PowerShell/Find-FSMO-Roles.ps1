#Find the Domain based FSMO Roles
Get-ADDomain
Get-ADDomain | Select-Object InfrastructureMaster,PDCEmulator,RIDMaster | Format-List

#Find the Forest based FSMO Roles
Get-ADForest | Select-Object DomainNamingMaster,SchemaMaster | Format-List


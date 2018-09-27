#Check current role location
Get-ADDomain | Select-Object InfrastructureMaster,RIDMaster | Format-List

#Transfer Infrastructure Master and RID Master roles
Move-ADDirectoryServerOperationMasterRole -OperationMasterRole InfrastructureMaster,RIDMaster -Identity PROD-DC02

#Confirm the move was successful
Get-ADDomain | Select-Object InfrastructureMaster,RIDMaster | Format-List
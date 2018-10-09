#region Removing a domain controller that is not the last one and the DC is still online

## Environment: Domain (techsnips.local), PROD-DC (online),PROD-DC02 (online)

## potential error if RemoveDnsDelegation $true
## "Verification of prerequisites for Domain Controller promotion failed. The argument RemoveDNSDelegation=Yes is invalid."

## More parameters here --> https://docs.microsoft.com/en-us/powershell/module/addsdeployment/test-addsdomaincontrolleruninstallation?view=win10-ps
## Test uninstall prerequisites
$testParams = @{
	LocalAdministratorPassword  = (ConvertTo-SecureString 'p@$$w0rd12' -AsPlainText -Force)
	RemoveApplicationPartitions = $true
}
Test-ADDSDomainControllerUninstallation @testParams

## Find any FSMO roles on the DC being demoted
Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster | Format-List
Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster | Format-List

## Move the RIDMaster and InfrastructureMaster to another DC
Move-ADDirectoryServerOperationMasterRole -OperationMasterRole RIDMaster, InfrastructureMaster -Identity PROD-DC

#Confirm the move was successful
Get-ADDomain | Select-Object RIDMaster, InfrastructureMaster | Format-List

## Perform removal
$removeParams = @{
	LocalAdministratorPassword  = (ConvertTo-SecureString 'p@$$w0rd12' -AsPlainText -Force)
	RemoveApplicationPartitions = $true
	RemoveDnsDelegation         = $true
}
Uninstall-AddsDomainController @removeParams

Uninstall-WindowsFeature AD-Domain-Services

#endregion
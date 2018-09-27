#Check current role location
Get-ADDomain | Select-Object PDCEmulator | Format-List

#Seize the PDCEmulator role
Move-ADDirectoryServerOperationMasterRole -OperationMasterRole PDCEmulator -Identity PROD-DC -Force

#Confirm the move was successful
Get-ADDomain | Select-Object PDCEmulator | Format-List
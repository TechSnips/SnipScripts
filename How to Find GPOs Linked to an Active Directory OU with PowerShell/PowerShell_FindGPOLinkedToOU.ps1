#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
Import-Module GroupPolicy
#endregion
#region clean
Function Prompt(){}
$OU = $LinkedGPOs = $LinkedGPOGUIDS = $GUID = $null
Clear-Host
#endregion

#region appetizer
Get-Module ActiveDirectory,GroupPolicy

$OU = "OU=Workstations,DC=TechSnipsDemo,DC=org"
Get-ADOrganizationalUnit $OU
#endregion

#region entree
$LinkedGPOs = Get-ADOrganizationalUnit $OU | Select-Object -ExpandProperty LinkedGroupPolicyObjects
$LinkedGPOs

$LinkedGPOGUIDs = $LinkedGPOs | ForEach-Object{$_.Substring(4,36)}
$LinkedGPOGUIDs

$LinkedGPOGUIDs | ForEach-Object {Get-GPO -Guid $_ | Select-Object DisplayName}
#endregion
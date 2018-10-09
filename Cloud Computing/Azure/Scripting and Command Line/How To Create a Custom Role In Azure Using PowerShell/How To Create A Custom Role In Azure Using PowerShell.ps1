#Connect-AzureRmAccount

#region Get Roles

Get-AzureRmRoleDefinition | select name, IsCustom, Description

#endregion


#region Get Actions

(Get-AzureRmRoleDefinition "Virtual Machine User Login").actions

Get-AzureRMProviderOperation | select Operation

#endregion


#region Create Role

$role = Get-AzureRmRoleDefinition "Virtual Machine User Login"

$role.Id = $null
$role.Name = "Virtual Machine Restarter"
$role.Description = "Can restart virtual machines."

$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action")

$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/00000000-0000-0000-0000-000000000000")

New-AzureRmRoleDefinition -Role $role

#endregion

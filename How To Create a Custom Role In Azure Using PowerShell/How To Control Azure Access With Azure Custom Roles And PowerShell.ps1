#Connect-AzureRmAccount

#region Get Roles

Get-AzureRmRoleDefinition | select name, IsCustom, Description

#endregion


#region Get Actions

(Get-AzureRmRoleDefinition "Virtual Machine Restarter").actions

#endregion


#region Create Role

$role = Get-AzureRmRoleDefinition "Virtual Machine User Login"

$role.Id = $null
$role.Name = "Virtual Machine Restarter"
$role.Description = "Can restart virtual machines."

$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action")

$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/191e6957-2351-484c-851b-c12eb10e61f0")

New-AzureRmRoleDefinition -Role $role

#endregion

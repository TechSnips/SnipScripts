<#
    Prerequisites:
        Azure CLI 2.0 Installed
    
    Notes:
#>
#Region
# Create a SP with a password
az ad sp create-for-rbac --name SNIPSrvPrin
az ad sp list --display-name SNIPSrvPrin
#EndRegion

#Region
# Manage a SP (by default it's assigned the 'Contributor role')
# https://docs.microsoft.com/en-gb/azure/role-based-access-control/built-in-roles
az role assignment create --assignee  --role Reader
az role assignment delete --assignee  --role Contributor
az role assignment list --assignee  
#Endregion

#Region
az login --service-principal  --username   --password   --tenant 
az logout 
# Login back in with a privileged account
az login
az ad sp delete --id 
#EndRegion

#Region
#Insert JSON Output from az ad sp create-for-rbac --name SNIPSrvPrin
#Endregion
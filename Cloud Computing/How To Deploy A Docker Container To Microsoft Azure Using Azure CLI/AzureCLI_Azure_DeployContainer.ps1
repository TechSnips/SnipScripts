$rGroup = 'Anthony_Containers'
$cName = 'containerazcli'

#region Show the resource group
az group show `
    --name $rGroup

#endregion

#region Create the container
az container create `
    --resource-group $rGroup `
    --name $cName `
    --image microsoft/aci-helloworld `
    --dns-name-label $cName `
    --ports 80

#endregion

#region Show the container
az container show `
    --resource-group $rGroup `
    --name $cName `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table

#endregion
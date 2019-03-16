Connect-AzAccount -Tenant ""

# 1- Verify the resource can be moved.
# 2- Check before moving the resource if in different subscription: 
#       - The source and destination subscriptions must exist within the same Azure Active Directory Tenant
#       - The account moving the resources must have at least the following permissions:
#            --Microsoft.Resources/subscriptions/resourceGroups/moveResources/action on the source resource group.
#            --Microsoft.Resources/subscriptions/resourceGroups/write on the destination resource group.
Get-AzResourceGroup | select-object ResourceGroupName,Tags
Get-AzResource | Select-Object Name,ResourceGroupName,Tags

#Selecting Destination Resource Group:
$DestinationRG = Get-AzResourceGroup -Name "RGName" 


#Selecting single Resource to be moved:
$singleResource = Get-AzResource | Where-Object {$_.Name -eq "ResouceName"}
#Selecting Multiple Resource to be moved:

$MultipleResources = Get-AzResource | Where-Object {$_.Tags.Keys -eq "Tag_Key"}

$DestinationRG | Select-Object ResourceGroupName,Tags
$singleResource | Select-object Name,ResourceGroupName
$MultipleResources | Select-Object Name,ResourceGroupName,Tags
#moving Single Resource: 

Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $singleResource.ResourceId

#Confirm movement : 
Get-AzResource | Where-Object {$_.Name -eq "ResouceName"}



#moving Multple Resources: 

foreach($Resource in $MultipleResources){

    write-host "Moving...$($Resource.Name)" -ForegroundColor Magenta
    Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $Resource.ResourceId -Force
    
}

#confirm movement: 
Get-AzResource | Where-Object {$_.Tags.Keys -eq "Tag_Key"} | select-object Name,ResourceGroupName | Format-table


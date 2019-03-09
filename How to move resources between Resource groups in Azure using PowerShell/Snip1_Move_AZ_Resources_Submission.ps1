
Connect-AzAccount -Tenant "Tenant Name"

# 1- Verify the resource can be moved.
# 2- Check before moving the resource if in different subscription: 
#       - The source and destination subscriptions must exist within the same Azure Active Directory Tenant
#       - The account moving the resources must have at least the following permissions:
#            --Microsoft.Resources/subscriptions/resourceGroups/moveResources/action on the source resource group.
#            --Microsoft.Resources/subscriptions/resourceGroups/write on the destination resource group.
$ResourceGroups = Get-AzResourceGroup
$Resources = Get-AzResource

#Selecting Destination Resource Group:
$DestinationRG = $ResourceGroups | Where-Object {$_.tags.Values -eq "Tag Value"}


#Selecting single Resource to be moved:
$singleResource = $Resources | Where-Object {$_.Name -eq "Name of the resource"}
#Selecting Multiple Resource to be moved:

$MultipleResources = $Resources | Where-Object {$_.Tags.Keys -eq "the tag key which is common between all the resource required"}

#moving Single Resource: 

Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $singleResource.ResourceId

#Confirm movement : 
Get-AzResource | Where-Object {$_.Name -eq "Name of the moved resource"}



#moving Multple Resources: 

foreach($Resource in $MultipleResources){

    write-host "Moving...$($Resource.Name)" -ForegroundColor Magenta
    Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $Resource.ResourceId -Force
    
}

#confirm movement: 
Get-AzResource | Where-Object {$_.Tags.Keys -eq "the tag key"} | select-object Name,ResourceGroupName | Format-table


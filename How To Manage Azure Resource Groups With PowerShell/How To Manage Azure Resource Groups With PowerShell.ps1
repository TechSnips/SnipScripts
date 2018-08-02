#region
New-AzureRmResourceGroup -Name TECHSNIP -Location 'UK South' -Tag @{Dept="IT"; Env="Test"} 
#endregion

#region
$tags += @{Dept="ACC";Value="Prod"} 
Set-AzureRmResourceGroup -Name TECHSNIP -Tag $tags
#endregion 

#region
Get-AzureRmResourceGroup
(Get-AzureRmResourceGroup).Count
(Get-AzureRmResourceGroup).ResourceGroupName
(Get-AzureRmResourceGroup | where{$_.ResourceGroupName -like '*europe*'}).ResourceGroupname
(Get-AzureRmResourceGroup -Name TECHSNIP).Tags
#endregion

#region
Remove-AzureRmResourceGroup -Name TECHSNIP -WhatIf
Remove-AzureRmResourceGroup -Name TECHSNIP -Force
#endregion
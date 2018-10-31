#region Header
<#

Pre-reqs:

    The 'AzureRM' module

Snip Suggestions:

    SCHEDULING AZURE VM STARTUP WITH AZURE AUTOMATION AND TAGS : https://www.techsnips.io/scheduling-azure-vm-startup-with-azure-automation-and-tags

Notes:

    https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tag

#>
#endregion

#region PreReqs

Import-Module AzureRM

Connect-AzureRmAccount

#endregion


#region Get Tags

Get-AzureRmTag -Detailed | select name,values

Get-AzureRMVM | where {$_.Tags.Values -like '*Company1*'} 

#endregion


#region Tagging a VM

$VM = Get-AzureRmVM -ResourceGroupName rg-we-TestVMs -Name TestVM03

Set-AzureRmResource -ResourceGroupName $VM.ResourceGroupName -ResourceType $VM.Type -ResourceName $VM.Name -Tag @{Billing="Company3"} -Force

#endregion


#region Tagging all the Thingd

Get-AzureRmResource -ResourceGroupName $VM.ResourceGroupName -ResourceName $VM.Name | Set-AzureRmResource -Tag @{Company="TechSnips.io";Department="Finance"} -Force

#endregion


#region Adding Tags

$Resource = Get-AzureRmResource -ResourceGroupName $VM.ResourceGroupName -ResourceName $VM.Name -ResourceType $VM.Type

$Resource.Tags.Add("Status", "Approved")

Set-AzureRmResource -Tag $Resource.Tags -ResourceId $Resource.ResourceId -Force

#endregion

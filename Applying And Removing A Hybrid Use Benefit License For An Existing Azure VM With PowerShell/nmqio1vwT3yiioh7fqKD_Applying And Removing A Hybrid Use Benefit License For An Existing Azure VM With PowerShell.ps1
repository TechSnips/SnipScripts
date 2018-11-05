
Connect-AzureRmAccount

$VMTarget = Get-AzureRmVM | Select-Object Name, ResourceGroupName, LicenseType | Out-GridView -PassThru

function Set-AzureRMVMHUBLicense ($VMTarget) {
    $vm = Get-AzureRmVM -ResourceGroup $VMTarget.ResourceGroupName -Name $VMTarget.Name
    $vm.LicenseType = "Windows_Server"
    Update-AzureRmVM -ResourceGroupName $VMTarget.ResourceGroupName -VM $vm
}

function Remove-AzureRMVMHUBLicense ($VMTarget) {
    $vm = Get-AzureRmVM -ResourceGroup $VMTarget.ResourceGroupName -Name $VMTarget.Name
    $vm.LicenseType = "None"
    Update-AzureRmVM -ResourceGroupName $VMTarget.ResourceGroupName -VM $vm
}

Set-AzureRMVMHUBLicense -VMTarget $VMTarget

Remove-AzureRMVMHUBLicense -VMTarget $VMTarget
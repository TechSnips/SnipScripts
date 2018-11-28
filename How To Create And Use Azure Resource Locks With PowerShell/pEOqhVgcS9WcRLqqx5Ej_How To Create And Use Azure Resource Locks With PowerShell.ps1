Connect-AzureRmAccount

New-AzureRmResourceLock     

$splat =@{
    LockName = 'ROLock'
    LockLevel = 'Readonly'
    ResourceGroupName = 'rg-we-TestVMs'
    Force = $true
}

New-AzureRmResourceLock @splat

Get-AzureRmResourceLock | Select-Object Name, ResourceName, Properties

Get-AzureRmResourceLock | Out-GridView -PassThru | Remove-AzureRmResourceLock -Force
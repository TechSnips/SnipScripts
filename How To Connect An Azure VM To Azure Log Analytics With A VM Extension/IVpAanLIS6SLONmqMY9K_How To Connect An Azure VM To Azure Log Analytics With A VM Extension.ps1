
$EXT = Get-AzureRmVmImagePublisher -Location "UKWest" | Get-AzureRmVMExtensionImageType | Get-AzureRmVMExtensionImage 
$EXT | Select-Object Type, PublisherName, Version | ft -AutoSize

$PublicSettings = @{"workspaceId" = "d45a477a-765f-40b3-8656-a721be15xxxx"}
$ProtectedSettings = @{"workspaceKey" = "3fuiw7DqvJ0OUWQ+Aj9/Z7Pw5YLGBKQw6kAbd6Qz8H2t7gc66YRbkwAnoZeL5JssXh9jZuy0OuJbFtLrQtxxxx=="}

$splat = @{
    ExtensionName = "Microsoft.EnterpriseCloud.Monitoring" 
    Publisher = "Microsoft.EnterpriseCloud.Monitoring" 
    ExtensionType = "MicrosoftMonitoringAgent" 
    ResourceGroupName = "RG-WE-TESTVMS" 
    VMName = "TestVM1"
    TypeHandlerVersion = "1.0"
    Settings = $PublicSettings
    ProtectedSettings = $ProtectedSettings
    Location = "westeurope"
    AsJob = $True
}
Set-AzureRmVMExtension @splat
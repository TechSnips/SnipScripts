#region
$parameters = @{
    'resourceGroupname'  = 'xxxxxxx'
    'extensionname'      = 'IIS'
    'vmname'             = 'TESTVM'
    'location'           = 'WestEurope'
    'publisher'          = 'Microsoft.Compute'
    'extensiontype'      = 'CustomScriptExtension'
    'TypeHandlerVersion' = '1.8'
    'settingstring'      = '{"commandToExecute":"powershell Add-WindowsFeature Web-Server;powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'
}
Set-AzureRmVMExtension @parameters
#endregion

#region
Get-AzureRmPublicIPAddress -ResourceGroupName "xxxxxxxx" -Name "xxxxxxx" | select IpAddress
#endregion
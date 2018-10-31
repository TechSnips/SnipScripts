<#
    Prerequisites:
        AWS Account
        IAM User Account Configured for use in Powershell
    Scenario:
        Spin up a quick server for testing
    Notes:
#>
#region
# Select Blueprint
Get-LSBlueprintList -Region eu-west-1 -ProfileName techsnips | Where-Object BlueprintId -like *windows_server_2016* | Format-Table -AutoSize
# Get Bundle List
Get-LSBundleList -Region eu-west-1 -ProfileName techsnips | Format-Table -AutoSize
#endregion

#region
# Create Instance
$parameters =@{
Blueprintid = 'windows_server_2016_2018_07_11'
BundleID = 'nano_win_2_0'
InstanceName = 'Win2016Server'
profilename = 'techsnips'
region = 'eu-west-1'
AvailabilityZone ='eu-west-1a'
}
New-LSInstance @parameters
#endregion

#region
    Get-LSInstance -InstanceName 'Win2016Server' -ProfileName techsnips -Region eu-west-1
    # Connect To Instance
    Get-LSInstanceAccessDetail -InstanceName 'Win2016Server' -ProfileName techsnips -Region eu-west-1
    #Stop Instance
    Stop-LSInstance -InstanceName 'Win2016Server' -ProfileName techsnips -Region eu-west-1
    (Get-LSInstance -InstanceName 'Win2016Server' -ProfileName techsnips -Region eu-west-1).State
    #Remove Instance
    Remove-LSInstance -InstanceName 'Win2016Server' -ProfileName techsnips -Region eu-west-1
#endregion
#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Basic demo
#Specify a GPO Name
$GPOName = 'Map all the drives!'

#Retrieve the report in XML format
Get-GPOReport -Name $GPOName -ReportType XML

#Convert the report to a usable object
[xml]$GPOReport = Get-GPOReport -Name $GPOName -ReportType XML

#Examine the XML GPO Report, looking for the drive map settings
$GPOReport
$GPOReport.GPO
$GPOReport.GPO.User
$GPOReport.GPO.User.ExtensionData
($GPOReport.GPO.User.ExtensionData | Where-Object Name -eq "Drive Maps").Extension
($GPOReport.GPO.User.ExtensionData | Where-Object Name -eq "Drive Maps").Extension.DriveMapSettings

#Examine one of the entries
$driveMapSettings = ($GPOReport.GPO.User.ExtensionData | Where-Object Name -eq "Drive Maps").Extension.DriveMapSettings
$drive = $driveMapSettings.Drive | Select-Object -First 1
$drive
$drive.Filters
$drive.Filters.FilterGroup
#endregion

#region Function
Function Get-GPODriveMaps{
    Param(
        [string]$GPOname
    )
    [xml]$gpo = Get-GPOReport -Name $GPOName -ReportType XML
    $driveMapSetings = ($gpo.GPO.user.ExtensionData | Where-Object Name -eq "Drive Maps").Extension.DriveMapSettings
    ForEach($drivemap in $driveMapSetings.drive){
        If($drivemap.Filters.FilterGroup){
            $groups = $drivemap.Filters.FilterGroup.Name
        }Else{
            $groups = $null
        }
        New-Object PSObject -Property @{
            "Letter" = $drivemap.Properties.Letter
            "Path" = $drivemap.Properties.Path
            "Group" = $groups
            "Order" = $drivemap.GPOSettingOrder
        }
    }
}

Get-GPODriveMaps 'Map all the drives!'
#endregion
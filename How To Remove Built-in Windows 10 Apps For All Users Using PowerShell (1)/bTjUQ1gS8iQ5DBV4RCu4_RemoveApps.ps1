#list Available apps
Get-Appxpackage

Get-AppxProvisionedPackage -Online 


# To Remove a single application
Get-AppxPackage *Print3d* 
Get-AppxPackage *Print3d* | Remove-AppxPackage

Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ Microsoft.WindowsCalculator

Remove-AppxProvisionedPackage -Online -PackageName Microsoft.WindowsCalculator_2018.1120.2026.0_neutral_~_8wekyb3d8bbwe


#Remove selected applications
# Build Out script

#Show Fields
Get-AppxPackage 

#Create list using Name field and open in editor
Get-AppxPackage | Select-Object Name | Out-file apps.txt | ise apps.txt


Get-AppxProvisionedPackage -Online | Select DisplayName | Out-File Papps.txt | ise papps.txt  



#Create an array
$ProvisionedAppPackageNames = @(
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.Getstarted"
    "microsoft.windowscommunicationsapps" #Mail, Calendar
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

#Show that the packages are there
foreach ($ProvisionedAppName in $ProvisionedAppPackageNames)
{
    Get-AppxPackage -Name $ProvisionedAppName
}


foreach ($ProvisionedAppName in $ProvisionedAppPackageNames)
{
    Get-AppxPackage -Name $ProvisionedAppName -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $ProvisionedAppName | Remove-AppxProvisionedPackage -Online
}
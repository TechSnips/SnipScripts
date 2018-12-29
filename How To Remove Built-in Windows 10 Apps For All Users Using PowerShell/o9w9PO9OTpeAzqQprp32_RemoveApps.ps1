$ProvivonedAppPackageNames = @(
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.GetStarted"
    "microsoft.windowscommunicationsapps" #Mail, Calendar
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.XBoxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

foreach ($ProvisionedAppName in $ProvivonedAppPackageNames) {
    Get-AppxPackage -Name $ProvisionedAppName -AllUsers | Remove-AppPackage
    Get-AppxProvisionedPackage -Online | Where DisplayName -EQ $ProvisionedAppName | Remove-AppxProvisionedPackage -Online
    
}
# Offline Server: Get list of installed modules

Get-Module -ListAvailable | Export-Clixml -Path 'E:\InstalledModules.xml'


# Workstation: Import installed modules & save their help to USB

$InstalledModules = Import-Clixml -Path 'E:\InstalledModules.xml'
Save-Help -Module $InstalledModules -DestinationPath 'E:\OfflineHelp'


# Offline Server: Update help from USB

Update-Help -SourcePath 'E:\OfflineHelp'
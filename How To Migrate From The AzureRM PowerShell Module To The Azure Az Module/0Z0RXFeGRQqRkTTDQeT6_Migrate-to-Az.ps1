#Check to see which version of AzureRM is installed
Get-Module -Name AzureRm -ListAvailable

#Uninstall the AzureRM module
Uninstall-Module -Name AzureRm

Get-Module -Name AzureRm* -ListAvailable

foreach ($AzModule in (Get-Module -Name AzureRm* -ListAvailable).Name | Get-Unique)
{
    Uninstall-Module $AzModule -Verbose
}

#Install the AzureRM module from the PowerShell Gallery
Install-Module -Name Az -AllowClobber

#Connect and authenticate to your Azure subscription
Connect-AzAccount

#Verify success by listing virtual machines
Get-AzVM -Location "canadacentral"

#Enable AzureRM compatibility aliases
Enable-AzureRmAlias -Scope CurrentUser

#Verify success by listing virtual machines using AzureRM alias
Get-AzureRmVM -Location "canadacentral"
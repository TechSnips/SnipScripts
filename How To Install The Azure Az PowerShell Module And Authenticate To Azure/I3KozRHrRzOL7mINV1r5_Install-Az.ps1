#Check to see if the module is already installed
Get-Module -Name Az* -ListAvailable

#Install the AzureRM module from the PowerShell Gallery
Install-Module -Name Az -AllowClobber

#Connect and authenticate to your Azure subscription
Connect-AzAccount

#Verify success by listing virtual machines
Get-AzVM -Location "canadacentral"

#Add the PowerShell Gallery as a trusted repository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PSRepository


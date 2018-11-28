#Check to see if the module is already installed
Get-Module -ListAvailable | Where-Object -Property Name -Like "*Azure*"

#Install the AzureRM module from the PowerShell Gallery
Install-Module -Name AzureRM

#Connect and authenticate to your Azure subscription
Connect-AzureRmAccount

#Verify success by listing resource groups
Get-AzureRmResourceGroup | Select-Object -Property ResourceGroupName,Location

#Add the PowerShell Gallery as a trusted repository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PSRepository


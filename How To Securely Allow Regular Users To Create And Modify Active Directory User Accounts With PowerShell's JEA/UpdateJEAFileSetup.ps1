
$filesPath = "c:\JEAUpdate"

cd $filesPath

# Create a directory for the JEA Module
New-Item -Path "$filesPath\ADUserUpdate" -ItemType Directory

# Create a .psm1 file
New-Item -Path "$filesPath\ADUserUpdate\ADUserUpdate.psm1"

# Create a module Manifest
New-ModuleManifest -Path "$filesPath\ADUserUpdate\ADUserUpdate.psd1" -RootModule ADUserUpdate.psm1

# Create a folder for the RoleCapabilites file
New-Item -Path "$filesPath\ADUserUpdate\RoleCapabilities" -ItemType Directory

# Create the RoleCapabilites file
$roleCapFilePath = "$filesPath\ADUserUpdate\RoleCapabilities\ADUserUpdate.psrc"

$roleCapParams = @{
	Path             = $roleCapFilePath
	ModulesToImport  = 'ActiveDirectory'
	VisibleCmdlets   = 'Get-ADUser','Set-ADUser'
}

New-PSRoleCapabilityFile @roleCapParams

# Open RoleCapabilites file to edit
ise "$filesPath\ADUserUpdate\RoleCapabilities\ADUserUpdate.psrc"

# Create a new PSSessionConfiguration File for configuring the new endpoint
$sessionFilePath = ".\ADUserUpdateEndpoint.pssc"

$sessionParams = @{
	SessionType         = 'RestrictedRemoteServer'
	Path                = $sessionFilePath
	RunAsVirtualAccount = $true
	RoleDefinitions     = @{ 'techsnips\JEAUpdate' = @{ RoleCapabilities = 'ADUserUpdate' } }
}

New-PSSessionConfigurationFile @sessionParams

# Test the PSSessionConfigurationFile
Test-PSSessionConfigurationFile -Path .\ADUserUpdateEndpoint.pssc

# Open Session Configuration File to edit
ISE .\ADUserUpdateEndpoint.pssc




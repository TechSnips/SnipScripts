
$filesPath = "c:\JEAAdmin"

cd $filesPath

# Create a directory for the JEA Module
New-Item -Path "$filesPath\ADUserAdmin" -ItemType Directory

# Create a .psm1 file
New-Item -Path "$filesPath\ADUserAdmin\ADUserAdmin.psm1"

# Create a module Manifest
New-ModuleManifest -Path "$filesPath\ADUserAdmin\ADUserAdmin.psd1" -RootModule ADUserAdmin.psm1

# Function for adding a new AD user
$functionText =  "
#requires -Module ActiveDirectory
function New-User {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]`$FirstName,
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]`$LastName,
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]`$Department
    )
    `$userName = '{0}{1}' -f `$FirstName.Substring(0,1),`$LastName
    `$password = '4tadfAGR5SHfd'
    `$secPw = ConvertTo-SecureString -String `$password -AsPlainText -Force

    `$newUserParams = @{
        GivenName = `$FirstName
        Surname = `$LastName
        Name = `$userName
        AccountPassword = `$secPw
        ChangePasswordAtLogon = `$true
        Enabled = `$true
        Department = `$Department
    }
        New-AdUser @newUserParams
}
"

Set-Content -Path "$filesPath\ADUserAdmin\ADUserAdmin.psm1" -Value $functionText

ise "$filesPath\ADUserAdmin\ADUserAdmin.psm1"

# Create a folder for the RoleCapabilites file
New-Item -Path "$filesPath\ADUserAdmin\RoleCapabilities" -ItemType Directory

# Create the RoleCapabilites file
$roleCapFilePath = "$filesPath\ADUserAdmin\RoleCapabilities\ADUserAdmin.psrc"

$roleCapParams = @{
	Path             = $roleCapFilePath
	ModulesToImport  = 'ActiveDirectory','ADUserAdmin'
	VisibleCmdlets   = 'New-ADUser', 'Get-ADUser','Set-ADUser','Remove-ADUser','ConvertTo-SecureString'
    VisibleFunctions = 'New-User'
}

New-PSRoleCapabilityFile @roleCapParams

# Open RoleCapabilites file to edit
ise "$filesPath\ADUserAdmin\RoleCapabilities\ADUserAdmin.psrc"

# Create a new PSSessionConfiguration File for configuring the new endpoint
$sessionFilePath = ".\ADUserAdminEndpoint.pssc"

$sessionParams = @{
	SessionType         = 'RestrictedRemoteServer'
	Path                = $sessionFilePath
	RunAsVirtualAccount = $true
    #ScriptsToProcess    = 'C:\ADScripts.ps1'
	RoleDefinitions     = @{ 'techsnips\JEAAdmin' = @{ RoleCapabilities = 'ADUserAdmin' } }
}

New-PSSessionConfigurationFile @sessionParams

# Test the PSSessionConfigurationFile
Test-PSSessionConfigurationFile -Path .\ADUserAdminEndpoint.pssc

# Open Session Configuration File to edit
ISE .\ADUserAdminEndpoint.pssc




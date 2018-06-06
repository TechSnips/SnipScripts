################################################################
################################################################
##                                                            ##
## Just Enough Administration Overview:                       ##
## https://docs.microsoft.com/en-us/powershell/jea/overview   ##
##                                                            ##
## Required: WMF 5.1                                          ##
##                                                            ##
################################################################
################################################################


# Create a directory for the JEA Module
New-Item -Path HelpDesk -ItemType Directory

# Crate a blank .psm1 file
New-Item -Path .\HelpDesk\HelpDesk.psm1

# Create a module Manifest
New-ModuleManifest -Path .\HelpDesk\HelpDesk.psd1 -RootModule HelpDesk.psm1

# Create a folder for the RoleCapabilites file
New-Item -Path .\HelpDesk\RoleCapabilities -ItemType Directory

# Create the RoleCapabilites file
New-PSRoleCapabilityFile -Path .\HelpDesk\RoleCapabilities\HelpDeskJEARole.psrc

# Open RoleCapabilites file to edit
ise .\HelpDesk\RoleCapabilities\HelpDeskJEARole.psrc

# Create a new PSSessionConfiguration File for configuring the new endpoint
New-PSSessionConfigurationFile -SessionType RestrictedRemoteServer -Path .\HelpDeskEndpoint.pssc

# Open Session Configuration File to edit
ISE .\HelpDeskEndpoint.pssc

# Test the PSSessionConfigurationFile
Test-PSSessionConfigurationFile -Path .\HelpDeskEndpoint.pssc



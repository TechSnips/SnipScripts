#region Environment Provider

# Get current available PowerShell Providers
Get-PSProvider

# Get current PS Drives for providers
Get-PSDrive

# Get a current value of an environment variable
Get-ChildItem -Path Env:\COMPUTERNAME

# Environment variables don't have children so Get-Item returns the same result
Get-Item -Path Env:\COMPUTERNAME

#endregion

#region Displaying Environment Variables

# Set location to the Env:\ PS Drive
Set-Location -Path Env:\

# We can now get environment variable values without specifying the PS Drive name
Get-ChildItem -Path COMPUTERNAME

# To view them all you can just run Get-ChildItem
Get-ChildItem
Get-ChildItem -Path Env:\ #NOTE: If you're in another PS Drive you'll need to still specify Env:\ in the -Path

# Using PowerShells expression parser instead of the PS Drive
$env:COMPUTERNAME

#endregion

#region Changing Environment Variables

# Current value of PATH environment variable
$env:PATH -split ';'

# Adding a new path to PATH
$env:PATH = $env:PATH + ';C:\Temp'

# Now with the added value
$env:PATH -split ';'

# Restart the  PowerShell session, now the added value is gone
$env:PATH -split ';'

###
# Alternatively with Get-Item and Set-Item
###

# Current value of PATH environment variable.
(Get-Item -Path Env:\PATH | Select-Object -ExpandProperty Value) -split ';'

# Adding a new path to PATH.
Set-Item -Path Env:PATH -Value ($Env:PATH + ";C:\Temp")

# Now with the added value.
(Get-Item -Path Env:\PATH | Select-Object -ExpandProperty Value) -split ';'

#endregion

#region Setting Environment Variables Persistently (With PowerShell Profiles)

# Current value of PATH environment variable
$env:Path -split ';'

# Add a line in the PowerShell profile to update the PATH environment variable when PowerShell starts.
code $PROFILE.CurrentUserAllHosts

# There are multiple files for PowerShell profiles, be sure to edit the correct one.
# In this Snip we are editing $PROFILE.CurrentUserAllHosts.  This and other options are listed below.
# $PROFILE.AllUsersAllHosts
# $PROFILE.AllUsersCurrentHost
# $PROFILE.CurrentUserAllHosts
# $PROFILE.CurrentUserCurrentHost

# Restart PowerShell session, the change is persistent as it is loaded when PowerShell loads the profile.
$env:Path -split ';'

#endregion

#region Creating New Environment Variables and Deleting Environment Variables

# Create an environment variable
New-Item -Path Env:\ -Name TechSnips -Value 'Is awesome!'

# Our new environment variable
Get-Item -Path Env:\TechSnips

# Delete an environment variable
Remove-Item -Path Env:\TechSnips

# Now its gone
Get-Item -Path Env:\TechSnips

#endregion

#region PowerShell Preferences that are Stored as Environment Variables

# Current value of PSModulePath environment variable
$env:PSModulePath -split ';'

# Adding a new path to PSModulePath
$env:PSModulePath = $env:PSModulePath + ';C:\Temp'

# Now with the added value
$env:PSModulePath -split ';'

#endregion

#region Using .NET [System.Environment] Methods

# Calling the GetEnvironmentVariables() static method
[System.Environment]::GetEnvironmentVariables()

# Viewing the value of the PATH environment variable for the current user
[System.Environment]::GetEnvironmentVariable('PATH', 'user')

# Viewing the value of the PATH environment variable for the machine
[System.Environment]::GetEnvironmentVariable('PATH', 'machine')

# Updating the PATH environment variable for my user using the SetEnvironmentVariable static method
$userPathEnvVar = [System.Environment]::GetEnvironmentVariable('PATH', 'user')
[System.Environment]::SetEnvironmentVariable("PATH", $userPathEnvVar + ";C:\TechSnips", "User")

# Now its present (even if restarting PowerShell)
[System.Environment]::GetEnvironmentVariable('PATH', 'user')

# If you are not running PowerShell as administrator or a user with administrator access you'll get an error
$path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
[System.Environment]::SetEnvironmentVariable("PATH", $path + ";C:\TechSnips", "Machine")

#endregion

#region About Help

# The help is always there for you!
Update-Help
Get-Help -Name about_Environment_Variables

#endregion
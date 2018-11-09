#Install the Remote Server Administration Tools on Windows 10 version 1809 and higher.

#Get a list of the available RSAT tools.
Get-WindowsCapability -Name RSAT* -Online

#Return the same information in a more concise format.
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State

#Return the count and store a list of the currently installed PowerShell modules in a variable named Modules.
(Get-Module -ListAvailable -OutVariable Modules).Count

#Return a count and store a list of the current shortcuts in the Administrative Tools folder in a variable.
(Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools' -OutVariable Shortcuts).Count

#Install all of the available RSAT tools.
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online | Out-Null

#Verify the tools were installed.
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State

#Retrieve a count of the currently installed modules and store them in a variable named ModulesRSAT.
(Get-Module -ListAvailable -OutVariable ModulesRSAT).Count

#Compare the PowerShell modules that existed prior and after the installation, storing them in a variable named NewModules.
Compare-Object -ReferenceObject $Modules -DifferenceObject $ModulesRSAT -Property Name -OutVariable NewModules

#Return a list of all of the newly added PowerShell commands broken down by PowerShell module.
Get-Command -Module $NewModules.Name | Sort-Object -Property Source | Format-Table -GroupBy Source

#Update the help for the commands in the newly added PowerShell modules.
Update-Help -Name $NewModules.Name

#Return a count and store a list of the current shortcuts in the Administrative Tools folder in a variable.
(Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools' -OutVariable ShortcutsRSAT).Count

#Return a list of the newly added shortcuts.
Compare-Object -ReferenceObject $Shortcuts -DifferenceObject $ShortcutsRSAT -Property Name

#Show the icons in the Administrative Tools folder.
Show-ControlPanelItem -Name 'Administrative Tools'

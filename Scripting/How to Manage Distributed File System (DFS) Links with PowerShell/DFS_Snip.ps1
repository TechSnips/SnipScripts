<# 
Prerequisites for Distributed File System Server Role
 * Active Directory
 * File and Storage Services role installed on a Windows Server:
   * Windows Server (Semi-Annual Channel)
   * Windows Server 2016
   * Windows Server 2012 R2
   * Windows Server 2012
   * Windows Server 2008 R2 Datacenter/Enterprise
   * 
   * 
Prerequisites for PowerShell cmdlets:
 * An administrator account with the proper permissions
 * RSAT Tools with the ‘File Services Tools - DFS Management Tools’ installed 
     [X] Role Administration Tools 
         [X] Role Administration Tools 
             [X] File Services Tools 
                 [X] DFS Management Tools

#>

# Download RSAT
# https://www.microsoft.com/en-us/download/details.aspx?id=45520
# Install RSAT DFS Management tools with PowreShell
Install-WindowsFeature FS-DFS-Namespace, RSAT-DFS-Mgmt-Con

$Domain = 'tech.io'

#region Get-DfsnRoot
 # Discover all DFS Namespaces in current domain
(Get-DfsnRoot -Domain $Domain).Where( {$_.State -eq 'Online'} ) | Select-Object -ExpandProperty Path

#endregion Get-DfsnRoot

#region Get-DfsnFolder
# Discover all DFS Links in current NameSpace
Get-DfsnFolder -Path "\\$Domain\AppRoot\*" | Select-Object -ExpandProperty Path

#endregion Get-DfsnFolder

#region New-DfsnFolder
# Create a new DFS Folder Name
# Try/Catch to see if the folder already exists
    try
    {
        Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell" -ErrorAction Stop
    }
    catch
    {
        Write-Host "Path not found. Clear to proceed" -ForegroundColor Green
    }

    # Splatting the Parameters for the New-DfsnFolder
$NewDFSFolder = @{
                 Path = "\\$Domain\AppRoot\PowerShell"
                 State = 'Online'
                 TargetPath = '\\datacenter\FileShare\PowerShell'
                 TargetState = 'Online'
                 ReferralPriorityClass = 'globalhigh'
                 }

New-DfsnFolder @NewDFSFolder

    # Check that folder now exists:
        Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

    # Check that the new DFS Link works using Windows Explorer
        Invoke-Expression "explorer '\\$Domain\AppRoot\PowerShell\'"
#endregion New-DfsnFolder

#region New-DfsnFolderTarget
# Splat the settings for easy readibility
$NewTPS = @{
    Path = "\\$Domain\AppRoot\PowerShell"
    TargetPath = '\\FileServer01\FileShare\PowerShell'
    State = 'Online'
    }

# Add new folder located on the 'FileServer01' server & set Online
New-DfsnFolderTarget @NewTPS

# Check that folder now exists:
Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

#endregion New-DfsnFolderTarget

#region New-DfsnFolderTarget-Offline

# Splat the settings for easy readibility
$NewTPS = @{
    Path = "\\$Domain\AppRoot\PowerShell"
    TargetPath = '\\FileServer02\FileShare\PowerShell'
    State = 'Offline'
    }

# Add new folder located on the 'FileServer02' server & set to Offline
New-DfsnFolderTarget @NewTPS

# Check that folder now exists:
Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

#endregion New-DfsnFolderTarget-Offline

#region Set-DfsnFolderTarget
# Creates a Folder Target path
# Splatting the settings where the path pointed at the server named FileServer01
$ChangeTPsFS1 = @{
    Path = "\\$Domain\AppRoot\PowerShell"
    TargetPath = '\\FileServer01\FileShare\PowerShell'
    State = 'Offline'
    }

# Set folder located on the server path 'FileServer01' to Offline
Set-DfsnFolderTarget @ChangeTPsFS1

# Splatting the settings where the path pointed at the server named FileServer02
$ChangeTPsFS2 = @{
    Path = "\\$Domain\AppRoot\PowerShell"
    TargetPath = '\\FileServer02\FileShare\PowerShell'
    State = 'Online'
    ReferralPriorityClass = 'globalhigh'
    }

# Set folder located on the 'FileServer02' server to Online
Set-DfsnFolderTarget @ChangeTPsFS2

# Splatting the settings where the path pointed at the server named Datacenter
$ChangeTPsFS3 = @{
    Path = "\\$Domain\AppRoot\PowerShell"
    TargetPath = '\\datacenter\FileShare\PowerShell'
    ReferralPriorityClass = 'sitecostnormal'
    }

# Change Priority of 'Datacenter' server folder path to 'Normal'
Set-DfsnFolderTarget @ChangeTPsFS3

# Check folder:
Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

#endregion Set-DfsnFolderTarget

#region Remove-DfsnFolderTarget
# Removes a path from a DFS Folder but does not remove the DFS Folder.
# Check Target Path to 'FileServer01' server to Offline & Remove the Folder Target Path
if ((Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"  -TargetPath '\\FileServer01\FileShare\PowerShell').State -eq "Offline")
{
    Remove-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell" -TargetPath '\\FileServer01\FileShare\PowerShell' -Force:$true
}

# Check folder:
Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

#endregion Remove-DfsnFolderTarget

#region Remove-DfsnFolder
# Removes a folder and all its paths
# Delete the DFS Folder
Remove-DfsnFolder -Path "\\$Domain\AppRoot\PowerShell" -Force:$true

# Final Check
  Get-DfsnFolderTarget -Path "\\$Domain\AppRoot\PowerShell"

#endregion Remove-DfsnFolder

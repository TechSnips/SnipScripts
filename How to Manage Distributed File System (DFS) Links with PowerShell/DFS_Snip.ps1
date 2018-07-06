# List Pre-Reqs
<#

1. Windows Server 2008 R2
2. Distributed File System role service installed   -or-
3. Remote Server Administration Tools feature > File Services Tools feature with the Distributed File System Tools

#>

#Get a list of all current DFS Namespaces using the "Get-DfsnRoot" command

#region Get-DFSNROOT

$Domain = 'tech.io'

(Get-DfsnRoot -Domain $Domain).Where( {$_.State -eq 'Online'} ) | Select-Object -ExpandProperty Path

#endregion Get-DFSNROOT

#List all DFS Links using the "Get-DfsnFolder" command

#region Get-DFSNFolder

$Domain = 'tech.io'

(Get-DfsnRoot -Domain $Domain).Where( {$_.State -eq 'Online'} ) | Select-Object -ExpandProperty Path

$DFSRoot = "\\$domain\DFSRoot"
$AppRoot = "\\$domain\AppRoot"

    $DFSRootLinks = Get-DfsnFolder -Path $DFSRoot\* | Select-Object -ExpandProperty Path
    $AppRootLinks = Get-DfsnFolder -Path $AppRoot\* | Select-Object -ExpandProperty Path


#endregion Get-DFSNFolder


#region Get-DfsnFolderTarget


$alltargetslisted = [System.Collections.ArrayList]@()

foreach ($AppRootLink in $AppRootLinks)
    {
        $allInfo = Get-DfsnFolderTarget -Path $AppRootLink
        $alltargetslisted.Add($allInfo) | out-null
    }

$alltargetslisted

#endregion Get-DfsnFolderTarget

#Create a new DFS Link using the "New-DfsnFolder" command

#region New-DfsnFolder

$NewDFSFolder = @{
                 Path = '\\Tech.io\AppRoot\PowerShell'
                 State = 'Online'
                 TargetPath = '\\FileServer01\FileShare\PowerShell' 
                 TargetState = 'Online' 
                 ReferralPriorityClass = 'globalhigh'
                 }

New-DfsnFolder @NewDFSFolder

#endregion New-DfsnFolder

#Update an existing DFS Folder Target using the "New-DfsnFolderTarget" command

#region New-DfsnFolderTarget

$NewTPS = @{
            Path = '\\Tech.io\AppRoot\PowerShell'
            TargetPath = '\\datacenter\ReplicatedFileShare\PowerShell'
            State = 'Online' 
            }

New-DfsnFolderTarget @NewTPS

$NewTPS = @{
            Path = '\\Tech.io\AppRoot\_PowerShell'
            TargetPath = '\\datacenter\ReplicatedFileShare\PowerShell' 
            State = 'Online' 
            }

New-DfsnFolderTarget @NewTPS

#endregion New-DfsnFolderTarget

#Remove a DFS Folder Target that is no longer required using the "Remove-DfsnFolderTarget"

#region Remove-DfsnFolderTarget

$DelFTS = @{
            Path = '\\Tech.io\AppRoot\_PowerShell'
            TargetPath = '\\THUNDERBLUFF\PowerShell'
            }

Remove-DfsnFolderTarget @DelFTS -Force:$true

#endregion Remove-DfsnFolderTarget

#Remove a DFS Folder that is no longer required using the "Remove-DfsnFolder"

#region Remove-DfsnFolder

Remove-DfsnFolder -Path '\\Tech.io\AppRoot\_PowerShell' -Force:$true

#endregion Remove-DfsnFolder
##########################################################################
#                                                                        #
# Managing File Shares with PowerShell                                   #
#                                                                        #
# Requirements:                                                          #
#     1. PowerShell 3.0+                                                 #
#     2. Windows 8/Windows Server 2012 0r higher                         #
#                                                                        #
# This script available at: https://github.com/TechSnips/SnipScripts     #
#                                                                        #
##########################################################################


Get-Command -Module smbshare -Name *smbshare*

# Get File Shares

Get-SmbShare

Get-SmbShare -Name C$ | select *

# Creating File Shares

New-SmbShare -Name Logs -Description "Log Files" -Path C:\Shares\Logs

# Modify File Share Properties

Set-SmbShare -Name Logs -Description "Application Log Files" –Force

Get-SmbShare -Name Logs

# Granting File Share Permissions

Get-SmbShareAccess -Name Logs

Grant-SmbShareAccess -Name Logs -AccountName corp\LogViewers -AccessRight Read -Force

Grant-SmbShareAccess -Name Logs -AccountName corp\LogAdmins -AccessRight Change –Force


# Remove File Share Permission

Revoke-SmbShareAccess -Name Logs -AccountName Everyone -Force

# Deny File Share Permission

Block-SmbShareAccess -Name Logs -AccountName corp\AppUsers –Force

# Remove Deny Permission From File Share

UnBlock-SmbShareAccess -Name Logs -AccountName corp\AppUsers –Force

# Remove File Share

Remove-SmbShare -Name Logs –Force

Get-SmbShare
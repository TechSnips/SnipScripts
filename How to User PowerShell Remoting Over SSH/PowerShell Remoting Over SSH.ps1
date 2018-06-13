
#region Info and Pre-requisites
<#======================================================================================================================
PowerShell Remoting Over SSH
  TechSnips - https://www.techsnips.io/playing/how-to-use-powershell-remoting-over-ssh
  GitHub - https://github.com/TechSnips/SnipScripts
========================================================================================================================
  References & Prerequisites:
========================================================================================================================
  PowerShell Core 6.0+ - Downloads
   - https://aka.ms/getps6-windows [Windows]
   - https://aka.ms/getps6-linux [macOS, Linux]
  OpenSSH
   - https://github.com/PowerShell/Win32-OpenSSH/releases [Downloads]
   - https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH [Installation]
======================================================================================================================#>
#endregion

#Enter the PS Remote Session [Creates an interactive remote session]
Enter-PSSession -HostName hts80magnus -SSHTransport -UserName uac\Ethan

#Create a new PS Remote Session [Creates a persistent remote session with one or more computers]
New-PSSession -HostName hts80magnus -SSHTransport -UserName uac\ethan # [KeyFilePath <string>]

#Executes a command on a local or remote computer
Invoke-command -HostName hts80magnus -SSHTransport -UserName uac\ethan -ScriptBlock {
    [System.Environment]::OSVersion.Version
}
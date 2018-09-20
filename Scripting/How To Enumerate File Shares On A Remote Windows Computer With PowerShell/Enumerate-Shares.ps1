#How To Enumerate File Shares On A Remote Windows Computer With PowerShell

#Remote to FILE01
Enter-PSSession -ComputerName FILE01

#Region Single Server
#All Shares
Get-SmbShare

#Exclude Admin Shares
Get-SmbShare -Special $false

#List all properties of a specific share
Get-SmbShare -Name Presentations | Select-Object -Property *

#List permissions for a specific share
Get-SmbShareAccess -Name Presentations

#List all users/groups with a specific permission
Get-SmbShareAccess -Name Presentations | Where-Object AccessRight -EQ "Full"

#Exit Session to File01
Exit-PSSession

#Endregion

#Region Multiple Servers
#List all shares on multiple servers using a manual list
Invoke-Command -ComputerName "FILE01","FILE02" -ScriptBlock {Get-SmbShare}

#List all non-admin shares on all servers in a single OU
$FileServAD = Get-ADComputer -SearchBase "OU=File Servers,OU=Servers,DC=corp,dc=ad" -Filter * | Select-Object -ExpandProperty Name 
Invoke-Command -ComputerName $FileServAD -ScriptBlock {Get-SmbShare -Special $false}

#Endregion
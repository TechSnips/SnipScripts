<# 

	Prerequisites
	=================
	- Active Directory domain
	- The Remote Server Administration Tools (RSAT) package installed
		 - contains the GroupPolicy module

	Environment
	=================
	- On a domain-joined Windows 10 machine
	- Using an account in the Domain Admins group

#>

#region Creating GPOs

## First create a GPO via the GPMC and define the setting we're after
## User Configuration\Policies\Administrative Templates\Desktops\Hide and Disable all items on the desktop

#region Find the registry.pol that the GPO stores registry keys in
Get-GPO -Name 'Temp'

## Find the GUID
$gpoGuid = (Get-GPO -Name 'Temp GPO').Id.ToString()

## Find the registry.pol file
$domainController = 'PROD-DC'
$domainName = 'techsnips.local'
$registryPolPath = "\\$domainController\sysvol\$domainName\Policies\{$gpoGuid}\User"
Get-ChildItem -Path $registryPolPath

$regPolPath = Join-Path -Path $registryPolPath -ChildPath 'registry.pol'

## download and install a community module for reading the registry.pol file
Install-Module -Name GPRegistryPolicy

Parse-PolFile -Path $regPolPath

## Capture the registry key path
$regKeyInfo = Parse-PolFile -Path $regPolPath

#endregion

#region Creating the GPO with the setting enabled

$gpoName = 'Hide Desktop Icons'
New-GPO -Name $gpoName -Comment 'This GPO hides all desktop icons.'

$gpRegParams = @{
	Name      = $gpoName
	Key       = "HKCU\$($regKeyInfo.KeyName)"
	ValueName = $regKeyInfo.ValueName
	Type      = $regKeyInfo.ValueType
	Value     = $regKeyInfo.ValueData
}
Set-GPRegistryValue @gpRegParams

## Confirm the registry setting has been applied
Get-GPRegistryValue -Name 'Hide Desktop Icons' -Key "HKCU\$($regKeyInfo.KeyName)"

#endregion

#region Link the GPO to an OU

$ou = 'People'
$domainDn = (Get-ADDomain).DistinguishedName

$ouDn = "OU=$ou,$domainDn"
New-GPLink -Name $gpoName -Target $ouDn -LinkEnabled 'Yes'

## Check the GPMC to ensure it's linked to the OU

#endregion

#endregion

#region Finding GPOs

Get-GPO -Name $gpoName
$gpoReport = Get-GPOReport -Name $gpoName -ReportType XML

[xml]$gpoReport

#endregion

#region Copying GPOs

Copy-GPO -SourceName $gpoName -TargetName 'Hide Desktop Icons2'

#endregion

#region Removing GPOs

Get-GPO -Name $gpoName | Remove-GPO

## Confirm gone in GPMC

#endregion
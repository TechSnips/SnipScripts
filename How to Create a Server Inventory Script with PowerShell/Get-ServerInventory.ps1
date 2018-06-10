<# Define what the output should look like
ServerName    IPAddress    OperatingSystem    AvailableDriveSpace (GB)   Memory (GB)    UserProfilesSize (MB)    StoppedServices
MYSERVER      x.x.x.x      Windows.....       10                         4              50.4                     service1,service2,service3
#>


#region All servers in a single OU in AD
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter *
$servers
#endregion

#region Narrow down servers to just the name
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
$servers
SQLSRV1
WEBSRV1
#endregion

#region Doing something with each server name
foreach ($server in $servers) {
	Write-Host $server
}
#endregion

#region Define all of the headers we know we're going to need
$output = [pscustomobject]@{
	'ServerName'               = $null
	'IPAddress'                = $null
	'OperatingSystem'          = $null
	'AvailableDriveSpace (GB)' = $null
	'Memory (GB)'              = $null
	'UserProfilesSize (MB)'    = $null
	'StoppedServices'          = $null
}
$output | Format-Table -AutoSize
#endregion

#region Put the data source (AD) together with the loop to get some real data in the output
```PowerShell
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	[pscustomobject]$output
}
#endregion

#region Querying Remote Files

Get-ChildItem -Path \\WEBSRV1\c$\Users -Recurse -File
Get-ChildItem -Path '\\WEBSRV1\c$\Uses\' -File | Measure-Object -Property Length -Sum
#endregion

#region Adding the user profile size to the final output
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	[pscustomobject]$output
}
#endregion

#region Converting user profile size to MB
$userProfileSize = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
$output.'UserProfilesSize (MB)' = $userProfileSize / 1GB
#endregion

#region Querying WMI

### Disk Free Space

## Figure out where the data lives in the CIM class
Get-CimInstance -ComputerName sqlsrv1 -ClassName Win32_LogicalDisk

## Only return the property we're looking for
(Get-CimInstance -ComputerName sqlsrv1 -ClassName Win32_LogicalDisk).FreeSpace

#region Incorporate the free size space in the loop
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = (Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB
	[pscustomobject]$output
}
#endregion

#region Round free space to make it more user-friendly
$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)


#region Find the OS name
$output.'<PropertyName>' = (Get-CimInstance -ComputerName <ServerName> -ClassName <WMIClassName>).<WMIClassPropertyName>

$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance -ComputerName $server -ClassName Win32_OperatingSystem).Caption
	[pscustomobject]$output
}
#endregion

#region Find memory

Get-CimInstance -ComputerName sqlsrv1 -ClassName Win32_PhysicalMemory

(Get-CimInstance -ComputerName sqlsrv1 -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB

$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance -ComputerName $server -ClassName Win32_OperatingSystem).Caption
	$output.'Memory (GB)' = (Get-CimInstance -ComputerName $server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
	[pscustomobject]$output
}
#endregion

#region Querying the IP address

Get-CimInstance -ComputerName SQLSRV1 -ClassName Win32_NetworkAdapterConfiguration

Get-CimInstance -ComputerName SQLSRV1 -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'" | Select-Object -Property *

(Get-CimInstance -ComputerName SQLSRV1 -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress

IPAddress                    : {192.168.0.40, fe80::e4e1:c511:e38b:4f05, 2607:fcc8:acd9:1f00:e4e1:c511:e38b:4f05}

(Get-CimInstance -ComputerName SQLSRV1 -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]

$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance -ComputerName $server -ClassName Win32_OperatingSystem).Caption
	$output.'Memory (GB)' = (Get-CimInstance -ComputerName $server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
	$output.'IPAddress' = (Get-CimInstance -ComputerName $server -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
	[pscustomobject]$output
}
#endregion

#region Querying Windows services

(Get-Service -ComputerName sqlsrv1 | Where-Object { $_.Status -eq 'Stopped' }).DisplayName

$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $server -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance -ComputerName $server -ClassName Win32_OperatingSystem).Caption
	$output.'Memory (GB)' = (Get-CimInstance -ComputerName $server -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
	$output.'IPAddress' = (Get-CimInstance -ComputerName $server -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
	$output.StoppedServices = (Get-Service -ComputerName $server | Where-Object { $_.Status -eq 'Stopped' }).DisplayName
	[pscustomobject]$output
}
#endregion

#region Using Format-Table
C:\Get-ServerInformation.ps1 | Format-Table -AutoSize
#endregion

#region Script Cleanup and Optimization

## Reusing the same CIM session
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$cimSession = New-CimSession -ComputerName $server
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -CimSession $cimSession -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance -CimSession $cimSession -ClassName Win32_OperatingSystem).Caption
	$output.'Memory (GB)' = (Get-CimInstance -CimSession $cimSession -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
	$output.'IPAddress' = (Get-CimInstance -CimSession $cimSession -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
	$output.StoppedServices = (Get-Service -ComputerName $server | Where-Object { $_.Status -eq 'Stopped' }).DisplayName
	Remove-CimSession -CimSession $cimSession
	[pscustomobject]$output
}
```

## Re-using the shared CIM session parameter
$serversOuPath = 'OU=Servers,DC=powerlab,DC=local'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
	$output = @{
		'ServerName'               = $null
		'IPAddress'                = $null
		'OperatingSystem'          = $null
		'AvailableDriveSpace (GB)' = $null
		'Memory (GB)'              = $null
		'UserProfilesSize (MB)'    = $null
		'StoppedServices'          = $null
	}
	$getCimInstParams = @{
		CimSession = New-CimSession -ComputerName $server
	}
	$output.ServerName = $server
	$output.'UserProfilesSize (MB)' = (Get-ChildItem -Path "\\$server\c$\Users\" -File | Measure-Object -Property Length -Sum).Sum
	$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance @getCimInstParams -ClassName Win32_LogicalDisk).FreeSpace / 1GB), 1)
	$output.'OperatingSystem' = (Get-CimInstance @getCimInstParams -ClassName Win32_OperatingSystem).Caption
	$output.'Memory (GB)' = (Get-CimInstance @getCimInstParams -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum /1GB
	$output.'IPAddress' = (Get-CimInstance @getCimInstParams -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
	$output.StoppedServices = (Get-Service -ComputerName $server | Where-Object { $_.Status -eq 'Stopped' }).DisplayName
	Remove-CimSession -CimSession $cimSession
	[pscustomobject]$output
}
#endregion
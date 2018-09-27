## Enter the remote server with PowerShell Remoting

Enter-PSSession -ComputerName 'WINSRV2016'

## Install both Windows features to install the Windows service and to configure the service via GUI, if necessary
Install-WindowsFeature -Name 'SNMP-Service', 'RSAT-SNMP'

## Set permitted managers by modifying the registry. This starts at 2 because, by default, 1 is already set to localhost

$managers = 'foo.techsnips.local', 'bar.techsnips.local'

$i = 2
foreach ($manager in $managers) {
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" -Name $i -Value $manager
	$i++
}

<# Set the community strings

We're getting a little fancy hwere but that's what PowerShell is for!
In the example below, I'm allowing myself to define all of the community strings _and_ their right level 
in a plain-English way. A read-only community string is defined as a 4 and a read/write community string 
is defined as an 8 but I don't want to remember that!

#>


$strings = @(
	@{
		Name   = 'ro'
		Rights = 'Read Only'
	}
	@{
		Name   = 'rw'
		Rights = 'Read Write'
	}
)

foreach ($string in $strings) {
	switch ($string.Rights) {
		'Read Only' {
			$val = 4
		}
		'Read Write' {
			$val = 8
		}
		default {
			throw "Unrecognized input: [$]"
		}
	}
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" -Name $string.Name -Value $val
	$i++
}

## Verify SNMP configuration in the services MMC
services.msc

#region Create a function to make this easier to deploy and to deploy on lots of servers at once

## Review function

## Dot-source to make available in session
. Install-SNMP.ps1

## Remove all permitted managers and community strings from server

## Execute
Install-SNMP -ComputerName WINSRV2016 -PermittedManagers 'foo.techsnips.local' -CommunityStrings @{'Name'='ro'; 'Rights'='Read Only'} -Verbose

## Verify via the SNMP Service service properties Security tab

#endregion
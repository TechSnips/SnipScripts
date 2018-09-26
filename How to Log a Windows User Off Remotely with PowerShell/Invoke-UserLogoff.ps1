<#
	.SYNOPSIS
		This script connects to a remote computer, checks for any user sessions and, if found, logs all sessions off.

	.EXAMPLE
		PS> .\Invoke-UserLogoff.ps1 -ComputerName FOO

		This example connects to the computer name of FOO and logs off all users.

	.EXAMPLE
		PS> .\Invoke-UserLogoff.ps1 -ComputerName FOO,BAR,BAZ

		This example connects to all computers and logs off all users on each computer.

	.EXAMPLE
		PS> .\Invoke-UserLogoff.ps1 -ComputerName FOO -UserName adam

		This example connects to the computer name of FOO, looks for users logged in matching username of Adam and logs him off.

	.PARAMETER ComputerName
		A mandatory string collection parameter representing one or more computer names separated by a comma to log off users from.

	.PARAMETER UserName
		An optional string parameter representing a single user to log off.

#>
[OutputType('void')]
[CmdletBinding(SupportsShouldProcess)]
param
(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string[]]$ComputerName,

	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$UserName
)

$ErrorActionPreference = 'Stop'

foreach ($c in $ComputerName) {
	## Find the user's session ID
	$compArgs = "/server:$c"
	$whereFilter = { '*' }
	if ($PSBoundParameters.ContainsKey('UserName')) {
		$whereFilter = [scriptblock]::Create("`$_ -match '$UserName'")
	}
	if ($sessions = ((quser $compArgs | Where-Object $whereFilter))) {
		$sessionIds = ($sessions -split ' +')[2]
		if ($PSCmdlet.ShouldProcess("UserName: $UserName", 'Logoff')) {
			$sessionIds | ForEach-Object {
				logoff $_ $compArgs
			}
		}
	} else {
		Write-Verbose -Message 'No users found matching criteria found.'
	}
}

[OutputType('void')]
[CmdletBinding(SupportsShouldProcess)]
param
(
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string[]]$ComputerName,

	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$UserName
)

$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('ComputerName')) {
	$ComputerName = 'localhost'
}

foreach ($c in $ComputerName) {
	## Find the user's session ID
	$compArgs = $null
	if ($PSBoundParameters.ContainsKey('ComputerName')) {
		$compArgs = "/server:$c"	
	}
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

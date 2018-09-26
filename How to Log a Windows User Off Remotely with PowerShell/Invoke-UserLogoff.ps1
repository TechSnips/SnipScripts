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

$scriptBlock = {
    $ErrorActionPreference = 'Stop'

    try {
	## Find all sessions matching the specified username
	$whereFilter = {'*'}
	if ($using:UserName) {
		$whereFilter = [scriptblock]::Create("`$_ -match '$using:UserName'")
	}
	$sessions = quser | Where-Object $whereFilter
		
        ## Parse the session IDs from the output
        $sessionIds = ($sessions -split ' +')[2]
        Write-Verbose -Message "Found $(@($sessionIds).Count) user login(s) on computer."
        ## Loop through each session ID and pass each to the logoff command
        $sessionIds | ForEach-Object {
            Write-Verbose -Message "Logging off session id [$($_)]..."
            logoff $_
        }
    } catch {
        if ($_.Exception.Message -match 'No user exists') {
            Write-Verbose -Message "The user [$($using:UserName)] is not logged in."
        } else {
            throw $_.Exception.Message
        }
    }
}

Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock

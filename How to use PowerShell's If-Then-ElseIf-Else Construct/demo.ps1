<#
Scenario: Read a file from a set of servers but validate if they're online first. If not, return an error.
If so, the file needs to contain the strings foo, bar or baz otherwise something is wrong.
#>

#region Simple loop
$servers = 'SRV1', 'localhost', 'SRV3'
foreach ($server in $servers) {
	Get-Content -Path "\\$server\c$\SomeFile.txt"
}
#endregion

#region Testing output of a command
Test-Connection -ComputerName OFFLINESERVERHERE -Quiet -Count 1
Test-Connection -ComputerName localhost -Quiet -Count 1
#endregion

#region Performing action on a single condition
<#
if (<expression here>) {
	## code to run if the expression evaluated to be True
}
#>
foreach ($server in $servers) {
	if (Test-Connection -ComputerName $server -Quiet -Count 1) {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	}
}
#endregion

#region Performing action on two conditions
foreach ($server in $servers) {
	if (Test-Connection -ComputerName $server -Quiet -Count 1) {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	} else {
		Write-Error -Message "The server [$server] is not responding!"
	}
}
#endregion

#region Performing action on more than two conditions
foreach ($server in $servers) {
	if (-not (Test-Connection -ComputerName $server -Quiet -Count 1)) {
		Write-Error -Message "The server [$server] is not responding"
	} elseif (-not (Test-Path -Path "\\$server\c$\SomeFile.txt")) {
	    Write-Error -Message "the file does not exist on server [$server]!"
	} else {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	}
}
#endregion
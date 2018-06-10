<#
Scenario: Read a file from a set of servers but validate if they're online first. If not, return an error.
If so, the file needs to contain the strings foo, bar or baz otherwise something is wrong.
#>

#region Simple loop
$servers = 'SRV1', 'SRV2', 'SRV3'
foreach ($server in $servers) {
	Get-Content -Path "\\$server\c$\SomeFile.txt"
}
#endregion

#region Testing output of a command
Test-Connection -ComputerName OFFLINESERVERHERE -Quiet -Count 1
Test-Connection -ComputerName ONLINESERVERHERE -Quiet -Count 1
#endregion

#region Performing action on a single condition
<#
if (<expression here>) {
	## code to run if the expression evaluated to be True
}
#>
$servers = 'SRV1', 'SRV2', 'SRV3'
foreach ($server in $servers) {
	if (Test-Connection -ComputerName $server -Quiet -Count 1) {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	}
}
#endregion

#region Performing action on two conditions
$servers = 'SRV1', 'SRV2', 'SRV3'
foreach ($server in $servers) {
	if (Test-Connection -ComputerName $server -Quiet -Count 1) {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	} else {
		Write-Error -Message "The server [$server] is not responding!"
	}
}
#endregion

#region Performing action on more than two conditions
$servers = 'SRV1', 'SRV2', 'SRV3'
foreach ($server in $servers) {
	if (Test-Connection -ComputerName $server -Quiet -Count 1) {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	} elseif (Test-Path -Path "\\$server\c$\SomeFile.txt") {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	} else {
		Write-Error -Message "The server [$server] is not responding, or the file does not exist!"
	}
}
#endregion

#region Generating errors on a condition
$servers = 'SRV1', 'SRV2', 'SRV3'
foreach ($server in $servers) {
	$filePath = "\\$server\c$\SomeFile.txt"
	if (-not (Test-Connection -ComputerName $server -Quiet -Count 1)) {
		Write-Error -Message "The server [$server] is not responding!"
	} elseif (-not (Test-Path -Path $filePath)) {
		Write-Error -Message "The file [$filePath] could not be found!"
	} else {
		Get-Content -Path "\\$server\c$\SomeFile.txt"
	}
}
#endregion

<#
switch (<expression>) {
	<expressionvalue> {
		## Do something with code here.
	}
	default {
		## Stuff to do if no matches were found
	}
}
#>

<#
Let's say a SomeFile.txt file contains the following string:

foo
bar

#>

#region Switch statement
switch ($fileContent) {
	'foo' {
		Write-Host "The file contained [$_]. We're good."
	}
	'bar' {
		Write-Host "The file contained [$_]. We're good."
	}
	'baz' {
		Write-Host "The file contained [$_]. We're good."
	}
	default {
		Write-Host "The file content [$_] did not contain any of the strings!"
	}
}
```
<#
When I run this, I get the following:

The file contained [foo]. We're good.
The file contained [bar]. We're good.
#>
#endregion

#region Using the break keyword
switch ($fileContent) {
	'foo' {
		Write-Host "The file contained [$_]. We're good."
		break
	}
	'bar' {
		Write-Host "The file contained [$_]. We're good."
		break
	}
	'baz' {
		Write-Host "The file contained [$_]. We're good."
		break
	}
	default {
		Write-Host "The file content [$_] did not contain any of the strings!"
	}
}
#endregion
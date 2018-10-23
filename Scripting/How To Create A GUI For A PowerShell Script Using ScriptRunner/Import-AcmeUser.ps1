#requires -Module ActiveDirectory

<#
	.SYNOPSIS
		This script creates one or more Active Directory users from input received via a CSV file. The CSV file is assumed
		to have the following fields defined: First Name, Last Name and Department. This script reads each row in the CSV
		file and creates a new Active Directory user based on the field values.

		NOTE: This script is meant to only work in AppSphere's ScriptRunner product. It uses some internal variables and
		will NOT work outside of ScriptRunner.

	.PARAMETER CsvFilePath
		The path to the CSV file that contains employee records.

	.EXAMPLE
		PS> & .\Import-AcmeUser.ps1 -CsvFilePath '\\SRV1\Employees\Employees.csv'

		This example reads each row in the \\SRV1\Employees\Employees.csv file presumed to be populated with new employee information.
		It then creates a new Active Directory user for each CSV row.
#>

param(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$CsvFilePath
)

$ErrorActionPreference = 'Stop'

try {
	if (-not (Get-Variable SRXEnv -ErrorAction Ignore)) {
		throw 'The script is not running in a ScriptRunner environment!'
	}
	if (-not (Test-Path -Path $CsvFilePath -PathType Leaf)) {
		throw "The CSV file [$($CsvFilePath)] could not be found."
	}
	Add-Type -AssemblyName 'System.Web'
	Import-Csv -Path $CsvFilePath | foreach {
		Write-Verbose -Message 'Generating random password...'
		$password = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 32), 3)
		$secPw = ConvertTo-SecureString -String $password -AsPlainText -Force

		Write-Verbose -Message 'Creating new Active Directory user...'
		$userName = '{0}{1}' -f $_.'First Name'.Substring(0, 1), $_.'Last Name'
		$NewUserParameters = @{
			GivenName       = $_.'First Name'
			Surname         = $_.'Last Name'
			Name            = $userName
			AccountPassword = $secPw
		}
		New-AdUser @NewUserParameters

		Write-Verbose -Message 'Adding new Active Directory user to group(s)...'
		Add-AdGroupMember -Identity $_.Department -Members $userName
	}

	$SRXEnv.ResultMessage = 'Successfully created all Active Directory users'
} catch {
	$SRXEnv.ResultMessage = 'ERROR: {0}' -f $_.Exception.Message
} finally {
	$SRXEnv.ResultMessage
}
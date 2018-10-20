<#
	
	Prerequisites:
		- Active Directory domain
		- CSV containing employee records
		- Remote Server Administration Tools (RSAT) installed (if running on a domain-joined computer)
	Scenario:
		- Read a CSV file
		- Check Active Directory for any objects
		- Create any new objects that don't already exist
	Notes:
		Recommended community module: PSADSync (Install-Module PSADSync)
	
#>

#region Inspect our CSV file and figure out mappings

Import-Csv -Path 'C:\Employees.csv'

<#
---------
Users
---------

CSV Field		|	Active Directory Attribute
===========================================
EmployeeID		|	EmployeeID
First Name		|	GivenName
Last Name		|	Surname
Phone Number 	|	OfficePhone

---------
Computers
---------

CSV Field		|	Active Directory Attribute
===========================================
ComputerName		|	Name

---------
Groups
---------

CSV Field		|	Active Directory Attribute
===========================================
Department		|	Name

---------
Organizational Units
---------

CSV Field		|	Active Directory Attribute
===========================================
Department		|	Name
#>

#endregion

#region Planning

## Grab all employees from the CSV
$csvUsers = Import-Csv -Path 'C:\Employees.csv'

## Build the code to come up with the samAccountName
$proposedUsername = '{0}{1}' -f $csvUser.'First Name'.Substring(0, 1), $csvUser.'Last Name'

## Build the code to check to see if a single user exists. Pick a random employee ID in AD that exists now
Get-AdUser -Filter "Name -eq 'abertram'"

## Build the code to check to see if a single group exists. Pick a random group in AD that exists now
Get-AdGroup -Filter "Name -eq 'Domain Admins'"

## Build the code to check to see if a single computer exists. Pick a random computer in AD that exists now
Get-AdComputer -Filter "Name -eq 'PROD-DC'"

## Build the code to check to see if a single OU exists. Pick a random OU in AD that exists now
Get-AdOrganizationalUnit -Filter "Name -eq 'People'"

#endregion

#region Remove any necessary duplicates for vulnerable objects

## Figure out all of the groups we're going to have to create
$groupsToCreate = $csvUsers.Department | Select-Object -Unique

## Figure out all of the OUs we're going to have to create
$ousToCreate = $csvUsers.Location | Select-Object -Unique

#endregion

#region Create objects that other objects depend on first

## Create the OUs
$ousToCreate.foreach({
		if (Get-AdOrganizationalUnit -Filter "Name -eq '$_'") {
			Write-Verbose -Message "The OU with name [$_] already exists."
		} else {
			New-AdOrganizationalUniit -Name $_
		}
	})

## Create the groups
$groupsToCreate.foreach({
		if (Get-AdGroup -Filter "Name -eq '$_'") {
			Write-Verbose -Message "The group with name [$_] already exists."
		} else {
			New-AdGroup -Name $_ -GroupScope DomainLocal
		}
	})

#endregion

#region Create the users and computers and adding to groups

foreach ($csvUser in $csvUsers) {

	## Check for and create the user
	$proposedUsername = '{0}{1}' -f $csvUser.'First Name'.Substring(0, 1), $csvUser.'Last Name'
	if (Get-AdUser -Filter "Name -eq '$proposedUsername'") {
		Write-Verbose -Message "The AD user [$proposedUsername] already exists."
	} else {
		$newUserParams = @{
			Name        = $proposedUsername
			Path        = "OU=$($csvUser.Location),DC=techsnips,DC=local"
			Enabled     = $true
			GivenName   = $csvUser.'First Name'
			Surname     = $csvuser.'Last Name'
			EmployeeID  = $csvuser.EmployeeID
			OfficePhone = 'Phone Number'
		}
		New-AdUser @newUserParams

		## Add the user to the departmental group
		Add-AdGroupMember -Identity $csvUser.Department -Members $proposedUsername
	}

	## Check for and create the computer accounts
	if (Get-AdComputer -Filter "Name -eq '$($csvUser.ComputerName)'") {
		Write-Verbose -Message "The AD computer with name [$($csvUser.ComputerName)] already exists."
	} else {
		New-AdComputer -Name $csvUser.ComputerName
	}
}

#endregion

#region Create a function to bring it together

function Sync-ActiveDirectory {
	[OutputType('null')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$CsvFilePath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$UserFieldSyncMap,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerNameField,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$GroupNameField,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$OrganizationalUnitNameField
	)

	$ErrorActionPreference = 'Stop'

	## Find the CSV users
	Write-Verbose -Message 'Finding CSV users...'
	$csvUsers = Import-Csv -Path $CsvFilePath

	## Create the OUs
	Write-Verbose -Message 'Syncing OUs...'
	($csvUsers.Location | Select-Object -Unique).foreach({
			if (Get-AdOrganizationalUnit -Filter "Name -eq '$_'") {
				Write-Verbose -Message "The OU with name [$_] already exists."
			} else {
				New-AdOrganizationalUniit -Name $_
			}
		})

	## Create the groups
	Write-Verbose -Message 'Syncing groups...'
	($csvUsers.Department | Select-Object -Unique).foreach({
			if (Get-AdGroup -Filter "Name -eq '$_'") {
				Write-Verbose -Message "The group with name [$_] already exists."
			} else {
				New-AdGroup -Name $_ -GroupScope DomainLocal
			}
		})

	## Create the users, computers and add to appropriate groups
	Write-Verbose -Message 'Syncing users and computers....'
	foreach ($csvUser in $csvUsers) {

		## Check for and create the user
		$proposedUsername = '{0}{1}' -f $csvUser.'First Name'.Substring(0, 1), $csvUser.'Last Name'
		if (Get-AdUser -Filter "Name -eq '$proposedUsername'") {
			Write-Verbose -Message "The AD user [$proposedUsername] already exists."
		} else {
			$newUserParams = @{
				Name        = $proposedUsername
				Path        = "OU=$($csvUser.Location),DC=techsnips,DC=local"
				Enabled     = $true
				GivenName   = $csvUser.'First Name'
				Surname     = $csvuser.'Last Name'
				EmployeeID  = $csvuser.EmployeeID
				OfficePhone = 'Phone Number'
			}
			New-AdUser @newUserParams

			## Add the user to the departmental group
			Add-AdGroupMember -Identity $csvUser.Department -Members $proposedUsername
		}

		## Check for and create the computer accounts
		if (Get-AdComputer -Filter "Name -eq '$($csvUser.ComputerName)'") {
			Write-Verbose -Message "The AD computer with name [$($csvUser.ComputerName)] already exists."
		} else {
			New-AdComputer -Name $csvUser.ComputerName
		}
	}
}

## To dynamically map CSV columns to AD attributes. CSV fields on the left, AD attributes on the right
$fieldSyncMap = @{
	'EmployeeID'   = 'EmployeeID'
	'First Name'   = 'GivenName'
	'Last Name'    = 'Surname'
	'Phone Number' = 'OfficePhone'
}

$parameters = @{
	CsvFilePath                 = 'C:\Employees.csv'
	UserFieldSyncMap            = $fieldSyncMap
	ComputerNameField           = 'ComputerName'
	GroupNameField              = 'Department'
	OrganizationalUnitNameField = 'Location'
	Verbose                     = $true
}
Sync-ActiveDirectory @parameters

#endregion
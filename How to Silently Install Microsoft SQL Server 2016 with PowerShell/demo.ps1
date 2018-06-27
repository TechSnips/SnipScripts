<#

Prereqs:

 - A remote Windows server with PSRemoting enabled
 - An ISO for SQL Server

Snip suggestions:

- HOW TO USE PARAMETER SPLATTING IN POWERSHELL
- HOW TO COPY FILES OVER WINRM WITH POWERSHELL

Outline:

- Copying a SQL Server answer file and changing attributes specific to our server at hand
- Copying the SQL Server ISO file to the soon-to-be SQL server
- Mounting the ISO file on the soon-to-be SQL server
- Running the SQL Server installer using the answer file copied earlier
- Dismounting the ISO file
- Cleaning up any temporary copied files on the SQL server

Notes:

 - Code is being run from the VM that SQL Server is being installed on (locally)

#>

#region Setup for PS remoting connections
$computerName = '23.96.10.116'
$credential = Get-Credential
Enter-PSSession -ComputerName $computerName -Credential $credential
#endregion

#region Creating and copying necessary files to the SQL Server

## Look at the answer file
Get-Content -Path 'C:\SqlServer.ini'

## Modify the template file for our use using PowerShell
$configContents = Get-Content -Path 'C:\SqlServer.ini' -Raw
$configContents = $configContents.Replace('SQLSVCACCOUNT=""', 'SQLSVCACCOUNT="TechSnipsUser"')
$configContents = $configContents.Replace('SQLSVCPASSWORD=""', 'SQLSVCPASSWORD="P@$$w0rd12"')
$configContents = $configContents.Replace('SQLSYSADMINACCOUNTS=""', 'SQLSYSADMINACCOUNTS="TechSnipsUser"')
Set-Content -Path 'C:\SqlServer.ini' -Value $configContents

## Look at the answer file on the remote server
Get-Content -Path 'C:\SqlServer.ini' | Select-String -Pattern 'SQLSVCACCOUNT=|SQLSVCPASSWORD=|SQLSYSADMINACCOUNTS='

## Copy the ISO file to the soon-to-be SQL server
$copyParams = @{
	Path        = 'C:\en_sql_server_2016_standard_x64_dvd_8701871.iso'
	Destination = 'C:\'
	ToSession   = $session
}
Copy-Item @copyParams
#endregion

#region Running the SQL Server Installer

## Setup scriptblock and params to Invoke-Command

## Mount the ISO on the remote server
$image = Mount-DiskImage -ImagePath 'C:\en_sql_server_2016_standard_x64_dvd_8701871.iso' -PassThru
		
## Figure out what drive letter the ISO was mounted with
$installerPath = "$(($image | Get-Volume).DriveLetter):"

## Start the installer passing the answer file copied earlier
$null = & "$installerPath\setup.exe" "/CONFIGURATIONFILE=C:\SqlServer.ini"

## Dismount the mounted ISO
$image | Dismount-DiskImage
#endregion

#region Clean up temp ISO and answer files
Remove-Item -Path 'C:\en_sql_server_2016_standard_x64_dvd_8701871.iso', "C:\SqlServer.ini"
#endregion

#region Creating a function to do it all from your local computer

function Install-SqlServer {
	param
	(
		[Parameter(Mandatory)]
		[string]$ComputerName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$SqlServiceAccount,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$SysAdminAccount,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$TemplateAnswerFilePath,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$IsoFilePath = 'C:\en_sql_server_2016_standard_x64_dvd_8701871.iso',

		[Parameter()]
		[pscredential]$Credential
	)

	try {
		## Create a PowerShell remoting session to copy files from to VM
		Write-Verbose -Message "Creating a new PSSession to [$($ComputerName)]..."

		$newSessParams = @{
			Name = $ComputerName
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$newSessParams.Credential = $Credential
		}
		$session = New-PSSession @newSessParams

		## Test to see if SQL Server is already installed
		if (Invoke-Command -Session $session -ScriptBlock { Get-Service -Name 'MSSQLSERVER' -ErrorAction Ignore }) {
			Write-Verbose -Message 'SQL Server is already installed'
		} else {

			## Copy the SQL server install template file to the remote server
			$copyParams = @{
				Path        = $TemplateAnswerFilePath
				Destination = 'C:\'
				Session     = $session
			}
			$tempFile = Copy-Item @copyParams

			## Modify the template file for our use using PowerShell
			$acctName = $SqlServiceAccount.Username
			$acctPwd = $SqlServiceAccount.GetNetworkCredential().Password
			$scriptBlock = {
				$configContents = Get-Content -Path 'C:\SqlServer.ini' -Raw
				$configContents = $configContents.Replace('SQLSVCACCOUNT=""', "SQLSVCACCOUNT=`"$using:acctName`"")
				$configContents = $configContents.Replace('SQLSVCPASSWORD=""', "SQLSVCPASSWORD=`"$using:acctPwd`"")
				$configContents = $configContents.Replace('SQLSYSADMINACCOUNTS=""', "SQLSYSADMINACCOUNTS=`"$using:SysAdminAccount`"")
				Set-Content -Path 'C:\SqlServer.ini' -Value $configContents
			}
			Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock -Credential $credential

			## Copy the ISO
			Write-Verbose -Message "Copying ISO file..."
			Copy-Item -Path $IsoFilePath -Destination 'C:\' -Force -ToSession $session

			$icmParams = @{
				Session      = $session
				ArgumentList = $AnswerFilePath, $IsoFilePath
				ScriptBlock  = {
					$image = Mount-DiskImage -ImagePath $args[1] -PassThru
					$installerPath = "$(($image | Get-Volume).DriveLetter):"
					$null = & "$installerPath\setup.exe" "/CONFIGURATIONFILE=C:\$($args[0])"
					$image | Dismount-DiskImage
				}
			}
			Invoke-Command @icmParams

			## Cleanup
			$scriptBlock = { Remove-Item -Path $using:IsoFilePath, $using:AnswerFilePath -ErrorAction Ignore }
			Invoke-Command -ScriptBlock $scriptBlock -Session $session
		}
		$session | Remove-PSSession
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

## Run a single function
$sqlSrvAccount = Get-Credential
$params = @{
	ComputerName           = $computerName
	SqlServiceAccount      = $sqlSrvAccount
	SysAdminAccount        = 'TechSnipsUser'
	TemplateAnswerFilePath = 'C:\SQLServer.ini'
	Credential             = $credential
}
New-SqlServer @params
#endregion
<#
	Prereqs: IIS installed on a remote server
#>

## Connect to remote web server
$computerName = '137.116.51.152'
$cred = Get-Credential
Enter-PSSession -ComputerName $computerName -Credential $credential

Import-Module WebAdministration

#region Discoverying IIS app pools

Get-Command -Name *apppool*

## Using the IIS drive
Get-ChildItem -Path IIS:\AppPools
Get-ItemProperty IIS:\AppPools\DefaultAppPool

## Using IIS cmdlet
Get-IISAppPool

## Finding the application pool associated with a web site
(Get-Website -Name 'Default Web Site').applicationpool

## Looking at attributes
(Get-Item -Path 'IIS:\AppPools\DefaultAppPool').processModel
(Get-Item -Path 'IIS:\AppPools\DefaultAppPool').processModel.attributes | Select-Object -Property Name, Value

#endregion

#region Creating IIS app pools

## Cmdlet
New-WebAppPool -Name 'AutomateBoringStuff'

## IIS drive
New-Item -Path IIS:\AppPools\AutomateBoringStuff2

#endregion

#region Setting attributes
Set-ItemProperty IIS:\AppPools\DefaultAppPool -name processModel -value @{userName="user_name"; password="password"; identitytype=3}
(Get-Item -Path 'IIS:\AppPools\DefaultAppPool').processModel.attributes | Select-Object -Property Name, Value
#endregion

#region Restarting app pools
Restart-WebAppPool -Name AutomateBoringStuff
#endregion

#region Removing IIS app pools
Remove-WebAppPool -Name AutomateBoringStuff
#endregion

#region Bringing it all together --creating a function
function New-IISAppPool {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,

		[Parameter()]
		[ValidateSet('v2', 'v4')]
		[string]$DotNetVersion = 'v4',

		[Parameter()]
		[switch]$RunAs32,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)

	try {
		#region Create scriptblock to apply configuration
		$scriptBlock = {

			$VerbosePreference = $Using:VerbosePreference

			$null = Import-Module -Name 'WebAdministration'

			# Build the full path of the application pool.
			$appPoolPath = 'IIS:\AppPools\{0}' -f $Using:Name

			#region Create application pool and apply customized default settings
			# Verify the specified application pool is not in use.
			if (Test-Path -Path $appPoolPath) {
				throw "IIS application pool [$using:Name] already exists."
			}

			# Create a new application pool.
			$null = New-Item -Path $appPoolPath

			# Set the application pool to use the specified .NET Runtime version.
			Set-ItemProperty -Path $appPoolPath -Name managedRuntimeVersion -Value ('{0}.0' -f $Using:DotNetVersion)

			# Set application pool to run as a 32-bit process if specified.
			if ($Using:RunAs32.IsPresent) {
				Set-ItemProperty -Path $appPoolPath -Name enable32BitAppOnWin64 -Value true
			}

			# Set custom default settings.
			Set-ItemProperty -Path $appPoolPath -Name processModel -Value @{ idletimeout = '0' }
			Set-ItemProperty -Path $appPoolPath -Name recycling -Value @{
				logEventOnRecycle = 'Time, Requests, Schedule, Memory, IsapiUnhealthy, OnDemand, ConfigChange, PrivateMemory'
			}
			#endregion Create application pool and apply customized default settings

		}
		#endregion Create scriptblock to apply configuration

		$icmParams = @{
			ScriptBlock  = $scriptBlock
			ComputerName = $ComputerName
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$icmParams.Credential = $Credential
		}

		Write-Verbose -Message "Creating new application pool '$Name' on the computer $ComputerName."
		Invoke-Command @icmParams
		Write-Verbose -Message "Application pool '$Name' created successfully."
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

## Create the app pool

## When no app pool exists
Invoke-Command -ComputerName $computerName -ScriptBlock { Remove-WebAppPool -Name AutomateBoringStuff } -Credential $cred
New-IISAppPool -Name AutomateBoringStuff -ComputerName $computerName -DotNetVersion v2 -Credential $cred -Verbose

## When the app pool does exist
New-IISAppPool -Name AutomateBoringStuff -ComputerName $computerName -Credential $cred -Verbose

#endregion
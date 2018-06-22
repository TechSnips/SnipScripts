<#
	Prereqs: 
		IIS installed on a remote server

	Snips:
		How to Manage IIS Application Pools with PowerShell
#>

## Connect to remote web server
$computerName = '40.70.25.104'
$credential = Get-Credential
Enter-PSSession -ComputerName $computerName -Credential $credential

Import-Module WebAdministration

#region Creating websites

## Getting all existing sites
Get-Website
Get-ChildItem -Path 'IIS:\Sites'

## Creating a simple website using the cmdlets
New-Website -Name AutomateBoringStuff -PhysicalPath C:\inetpub\wwwroot\

## Creating a more complicated website using the IIS drive
New-Item -Path "IIS:\Sites" -Name "AutomateBoringStuffAdvanced" -Type Site -Bindings @{protocol="http"; bindingInformation="*:8021:"}
Set-ItemProperty -Path "IIS:\Sites\AutomateBoringStuffAdvanced" -name "physicalPath" -value "C:\Sites\AutomateBoringStuffAdvanced"
Set-ItemProperty -Path "IIS:\Sites\AutomateBoringStuffAdvanced" -Name "id" -Value 4
New-ItemProperty -Path "IIS:\Sites\AutomateBoringStuffAdvanced" -Name "bindings" -Value @{protocol="http"; bindingInformation="*:8022:"}

#endregion

#region Modifying existing websites

## Stopping/starting websites
Get-Website -Name AutomateBoringStuff | Format-Table -AutoSize

## Obscure error message
Get-Website -Name AutomateBoringStuffAdvanced | Start-Website

## Let's track down the conflicting binding

## Bindings for current site
(Get-Website -Name AutomateBoringStuff).Bindings.Collection

## Find all sites with the same port binding but not the current one.
$site = Get-Website | where {$_.Bindings.Collection.bindingInformation -eq '*:80:' -and $_.Name -ne 'AutomateBoringStuff'}
$site

## Change the port binding on our new site to not conflict
Set-ItemProperty -Path "IIS:\Sites\AutomateBoringStuff" -Name "bindings" -Value @{protocol="http"; bindingInformation="*:81:"}

## Site starts successfully now
Get-Website -Name AutomateBoringStuff | Start-Website

## Changing the physical path
Set-ItemProperty -Path "IIS:\Sites\AutomateBoringStuffAdvanced" -name "physicalPath" -value "C:\Sites\AutomateBoringStuffAdvanced\1.1"

(Get-Website -Name AutomateBoringStuffAdvanced).physicalPath
Get-Website -Name AutomateBoringStuffAdvanced | Start-Website

## Changing logging settings
$settings = @{
	logFormat = "W3c"; # Formats:   W3c, Iis, Ncsa, Custom
	enabled   = $true
	directory = "C:\Sites\Logs"
	period    = "Daily"
}

Set-ItemProperty "IIS:\Sites\AutomateBoringStuffAdvanced" -name "logFile" -value $settings

Get-ItemProperty "IIS:\Sites\AutomateBoringStuffAdvanced" -name "logFile"

# The section paths are:
# 
#  Anonymous: system.webServer/security/authentication/anonymousAuthentication
#  Basic:     system.webServer/security/authentication/basicAuthentication
#  Windows:   system.webServer/security/authentication/windowsAuthentication

#endregion

#region Removing websites

Get-Website -Name AutomateBoringStuff | Remove-Website
Remove-Item IIS:\Sites\TestSite\AutomateBoringStuff

exit
#endregion

#region Putting it all together
function New-IISWebsite {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ApplicationPoolName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$HostHeader,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$IPAddress = '*',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$PhysicalPath,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[UInt16]$Port = 80,

		[Parameter()]
		[pscredential]$Credential,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Force
	)

	try {
		# Validate IP address if specified.
		if ($IPAddress -ne '*') {
			if (![System.Net.IPAddress]::TryParse($IPAddress, [ref][System.Net.IPAddress]::Any)) {
				throw "The IP address [$($IPAddress)] is invalid."
			}
		}

		#region Create scriptblock to apply configuration
		$scriptBlock = {

			$VerbosePreference = $Using:VerbosePreference

			$null = Import-Module -Name 'WebAdministration'

			# Check if a physical path was specified or if one should be generated from the website name.
			# Build the full website physical path if not specified.
			$websitePhysicalPath = "C:\inetpub\sites\{0}" -f $Using:Name
			if ($Using:PhysicalPath) {
				# Use the specified physical path.
				$websitePhysicalPath = $Using:PhysicalPath
			}
			Write-Verbose "Website physical path: $websitePhysicalPath"

			# Build the PSProvider path for the website.
			$websitePath = "IIS:\Sites\{0}" -f $Using:Name

			#region Create website and apply customized default settings
			if (Test-Path -Path $websitePath) {
				throw "The IIS website [$Using:Name] already exists."
			}

			# Verify application pool exists.
			Write-Verbose 'Verifying application pool exists'
			$appPoolPath = "IIS:\AppPools\{0}" -f $Using:ApplicationPoolName
			if (-not (Test-Path -Path $appPoolPath)) {
				throw "The IIS application pool [$($Using:ApplicationPoolName)] does not exist."
			}

			#region Create website physical path
			# Check if website physical path does not already exist.
			if (-not (Test-Path -Path $websitePhysicalPath)) {
				# Create the physical path.
				$null = New-Item -Path $websitePhysicalPath -ItemType Directory -Force
			}

			# Check if the Force flag was specified, which indicates that an existing directory can be used.
			# If not, throw an error because the physical path already exists.
			elseif (-not $Using:Force.IsPresent) {
				throw "IIS website physical path [$($websitePhysicalPath)] already exists."
			}
			#endregion Create website physical path

			# Check if there are any existing websites. If not, we need to specify the ID, otherwise the action
			# will fail.
			if ((Get-ChildItem -Path IIS:\Sites).Count -eq 0) {
				$websiteParams = @{
					id = 1
				}
			}

			# Create the website with the specified parameters.
			$websiteParams += @{
				Path         = $websitePath
				bindings     = @{
					protocol           = 'http'
					bindingInformation = '{0}:{1}:{2}' -f $Using:IPAddress, $Using:Port, $Using:HostHeader
				}
				physicalPath = $websitePhysicalPath
			}

			Write-Verbose "Creating website '$Using:Name' with specified parameters"
			$null = New-Item @websiteParams

			# Set the custom default settings.
			Write-Verbose 'Setting custom default settings...'
			Set-ItemProperty -Path $websitePath -Name applicationPool -Value $Using:ApplicationPoolName
			Set-ItemProperty -Path $websitePath -Name applicationDefaults.preloadEnabled -Value True
			#endregion Create website and apply customized default settings
		}
		#endregion create scriptblock to be executed remotely.

		$icmParams = @{
			ComputerName = $ComputerName
			ScriptBlock  = $scriptBlock
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$icmParams.Credential = $Credential
		}

		Write-Verbose -Message "Creating new website '$Name' on the computer $ComputerName."
		Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock $scriptBlock
		Write-Verbose -Message "Website '$Name' created successfully."
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

New-IISWebsite -Name Automate -ApplicationPoolName Automate -ComputerName $computerName -Credential $credential -Verbose -Force

## Create the app pool
Invoke-Command -ComputerName $computerName -Credential $credential -ScriptBlock { New-WebAppPool -Name Automate }

## Yay!
New-IISWebsite -Name Automate -ApplicationPoolName Automate -ComputerName $computerName -Credential $credential -Verbose -Force

#endregion
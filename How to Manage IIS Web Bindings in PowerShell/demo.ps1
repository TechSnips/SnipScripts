<#
	Prereqs: 
		IIS installed on a remote server
		PowerShell v5+ on remote server

	Snip prereqs:
		How to Create A Self-Signed Certificate with PowerShell
#>

## Connect to remote web server
$computerName = '40.70.25.104'
$credential = Get-Credential
Enter-PSSession -ComputerName $computerName -Credential $credential

Import-Module WebAdministration

#region Setting web bindings

Get-Website -Name 'Default Web Site'

Get-WebBinding -Name 'Default Web Site' | Select *

Set-WebBinding -Name 'Default Web Site' -BindingInformation "*:85:" -PropertyName Port -Value 81

Get-WebBinding -Name 'Default Web Site'
(Get-Website -Name 'Default Web Site').bindings.Collection

## exit existing interactive PowerShell session
#endregion

#region Putting it all together -- creating a custom function to create a new binding
function New-IISWebBinding {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$WebsiteName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('http', 'https')]
		[string]$Protocol,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[int]$Port,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ipaddress]$IPAddress = '0.0.0.0', ## Default to accepting on all bound IPs

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)

	try {
		$IPAddress = $IPAddress.IPAddressToString
		$iisIp = $IPAddress
		if ($IPAddress -eq '0.0.0.0') {
			$iisIp = '*'
		}

		$sb = {
			Import-Module WebAdministration
			if (Get-WebBinding -Protocol $Using:Protocol -Port $Using:Port) {
				throw "There's already a binding with the protocol of [$($Using:Protocol)] and port [$($Using:Port)]"
			}
			New-WebBinding -Name $Using:WebsiteName -IP $Using:iisIp -Port $Using:Port -Protocol $Using:Protocol
		}

		$icmParams = @{
			'ComputerName' = $ComputerName
			'ScriptBlock'  = $sb
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$icmParams.Credential = $Credential
		}
		Invoke-Command @icmParams
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

## Creating a simple HTTP binding
$parameters = @{
	ComputerName = $computerName
	Credential   = $credential
	WebsiteName  = 'Default Web Site'
	Protocol     = 'http'
	Port         = 82
}

New-IISWebBinding @parameters

## Check out the new binding
Invoke-Command -ComputerName $computerName -Credential $credential -ScriptBlock { Get-WebBinding -Name 'Default Web Site' }

#endregion

#region Putting it all together -- creating a custom function to change binding
function Set-IISBinding {
	[OutputType([void])]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Port,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$BindingIpAddress = '*',

		[Parameter(ParameterSetName = 'SSLBinding')]
		[ValidateNotNullOrEmpty()]
		[ValidateLength(40, 40)]
		[string]$CertificateThumbprint,

		[Parameter(ParameterSetName = 'SSLBinding')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('CurrentUser', 'LocalMachine')]
		[string]$Location = 'LocalMachine',

		[Parameter(ParameterSetName = 'SSLBinding')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('TrustedPublisher',
			'ClientAuthIssuer',
			'Remote Desktop',
			'Root',
			'TrustedDevices',
			'CA',
			'REQUEST',
			'AuthRoot',
			'TrustedPeople',
			'My',
			'SmartCardRoot',
			'Trust',
			'Disallowed')]
		[string]$CertificateStoreName = 'My',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)

	try {
		$icmParams = @{
			ComputerName = $ComputerName
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$icmParams.Credential = $Credential
		}
		Invoke-Command @icmParams -ScriptBlock {
			$VerbosePreference = $Using:VerbosePreference
			Import-Module WebAdministration
			if ($Using:CertificateThumbprint) {
				$certPath = "Cert:\$Using:Location\$Using:CertificateStoreName\$Using:CertificateThumbprint"
				$iisPath = "IIS:\SSLBindings\$Using:BindingIpAddress!$Using:Port"
				Write-Verbose -Message "Updating SSL binding for cert [$($certPath)] on [$($iisPath)]"
				Get-Item -Path $certPath  | Set-Item -Path $iisPath
			}
		}
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

## Find the cert on the remote web server
$cert = Invoke-Command -Credential $credential -ComputerName $computerName -ScriptBlock { Get-ChildItem -Path 'Cert:\LocalMachine\My' | Where-Object { $_.Subject -match 'techsnips' } }
$cert

## Modify the AutomateBoringStuff site to use new certificate
Set-IISBinding -ComputerName $computerName -Credential $credential -Port 8080 -CertificateThumbprint $cert.Thumbprint

## Check SSL bindings
Invoke-Command -ComputerName $computerName -Credential $credential -ScriptBlock { Import-Module webadministration; Get-ChildItem IIS:\SSLBindings } | select ipaddress, port, thumbprint

#endregion
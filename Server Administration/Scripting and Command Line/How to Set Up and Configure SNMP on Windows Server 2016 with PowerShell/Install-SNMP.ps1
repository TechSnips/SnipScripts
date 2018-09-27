function Install-SNMP {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string[]]$ComputerName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string[]]$PermittedManagers,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[hashtable[]]$CommunityStrings,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)

	$ErrorActionPreference = 'Stop'

	try {
		$scriptBlock = {
			$VerbosePreference = $using:VerbosePreference
			## Install the service and remote GUI configuraiton ability
			$null = Install-WindowsFeature -Name 'SNMP-Service', 'RSAT-SNMP'

			if ($using:PermittedManagers) {
				## Set any managers
				$i = 2
				foreach ($manager in $using:PermittedManagers) {
					Write-Verbose -Message "Setting permitted manager [$($manager)]..."
					$null = New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" -Name $i -Value $manager
					$i++
				}
				$strings = @(
					@{
						Name   = 'ro'
						Rights = 'Read Only'
					}
					@{
						Name   = 'rw'
						Rights = 'Read Write'
					}
				)
			}

			if ($using:CommunityStrings) {
				## Set any community strings
				foreach ($string in $using:CommunityStrings) {
					Write-Verbose -Message "Setting community string [$($string.Name)]..."
					switch ($string.Rights) {
						'Read Only' {
							$val = 4
						}
						'Read Write' {
							$val = 8
						}
						default {
							throw "Unrecognized input: [$]"
						}
					}
					$null = New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" -Name $string.Name -Value $val
					$i++
				}
			}
		}

		$icmParams = @{
			ComputerName = $ComputerName
			ScriptBlock  = $scriptBlock
			Verbose      = $VerbosePreference
		}
		if ($PSBoundParameters.ContainsKey('Credential')) {
			$icmParams.Credential = $Credential
		}
		Invoke-Command @icmParams
	} catch {
		Write-Error -Message $_.Exception.Message
	}
}
#requires -Module AzureRm

function Connect-TechSnipsVm {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('PSRemoting', 'RDP')]
		[string]$ConnectionMethod,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)
	
	DynamicParam {
		$RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
		$AttribColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
		$ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
		$ParamAttrib.Mandatory = $true
		$ParamAttrib.ParameterSetName = '__AllParameterSets'
		$AttribColl.Add($ParamAttrib)

		$vSetOptions = (Get-AzureRmVM | Select-Object -ExpandProperty Name | Sort-Object)
		$AttribColl.Add((New-Object System.Management.Automation.ValidateSetAttribute($vSetOptions)))
		$RuntimeParamDic.Add('Name', (New-Object System.Management.Automation.RuntimeDefinedParameter('Name', [string], $AttribColl)))
		
		return $RuntimeParamDic
	}
	
	begin {
		function Wait-WinRM {
			[CmdletBinding()]
			param (
				[Parameter(Mandatory)]
				[string]$ComputerName,

				[Parameter()]
				[pscredential]$Credential,

				[Parameter()]
				[ValidateNotNullOrEmpty()]
				[ValidateRange(1, [Int64]::MaxValue)]
				[int]$Timeout = 30
			)
			try {

				$icmParams = @{
					ComputerName  = $ComputerName
					Credential    = $Credential
					Authentication = 'CredSSP'
					ScriptBlock   = { $true }
					SessionOption = (New-PSSessionOption -NoMachineProfile -OpenTimeout 20000 -SkipCACheck -SkipRevocationCheck)
					ErrorAction   = 'SilentlyContinue'
					ErrorVariable = 'err'
				}

				$timer = [Diagnostics.Stopwatch]::StartNew()
				while (-not (Invoke-Command @icmParams)) {
					Write-Verbose -Message "Waiting for [$($ComputerName)] to become available to WinRM..."
					if ($timer.Elapsed.TotalSeconds -ge $Timeout) {
						$false
						return
					}
					Start-Sleep -Seconds 10
				}
				$true
			} catch {
				$PSCmdlet.ThrowTerminatingError($_)
				$false
			} finally {
				if (Test-Path -Path Variable:\Timer) {
					$timer.Stop()
				}
			}
		}

		function Wait-AzureRmVmState {
			[OutputType('void')]
			[CmdletBinding()]
			param
			(
				[Parameter(Mandatory, ValueFromPipeline)]
				[ValidateNotNullOrEmpty()]
				[string]$VMName,

				[Parameter(Mandatory)]
				[ValidateNotNullOrEmpty()]
				[ValidateSet('VM running')]
				[string]$DesiredState,

				[Parameter()]
				[ValidateNotNullOrEmpty()]
				[int]$RetryInterval = 5
			)

			while ((Get-AzureRmVm -Status | where {$_.Name -eq $VMName}).powerstate -ne $DesiredState) {
				Write-Verbose "Waiting for VM to reach the state of [$($DesiredState)]..."
				Start-Sleep -Seconds $RetryInterval
			}
		}

		function Get-AzurePublicIp {
			[CmdletBinding()]
			param(
				[parameter()]
				$Vm
			)

			$nicName = $vm.NetworkProfile[0].NetworkInterfaces.Id.Split('/')[-1]

			## Find the public IP ID
			$nic = Get-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $vm.ResourceGroupName
			$pubIpId = $nic.IpConfigurations.publicIpAddress.Id

			## Find the public IP using the ID of the public IP address
			$pubIpObject = Get-AzureRmPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where-Object { $_.Id -eq $pubIpId }
			$pubIpObject.IpAddress
		}

		$PsBoundParameters.GetEnumerator() | foreach { New-Variable -Name $_.Key -Value $_.Value -ea 'SilentlyContinue' }
	}

	process {
		$ctx = Get-AzureRmContext
		if (-not $ctx.Environment) {
			Write-Verbose -Message 'Connecting to Azure...'
			$null = Connect-AzureRmAccount -Subscription TechSnips -Credential $Credential
		}

		Write-Verbose -Message 'Getting VM status...'
		$vm = Get-AzureRmVM -Status | where { $_.name -eq $Name}
		if ($vm.powerstate -ne 'VM running') {
			Write-Verbose -Message 'VM is not running yet. Starting up...'
			$null = $vm | Start-AzureRmVm
			Wait-AzureRmVmState -VM $vm -DesiredState 'VM running'
		} else {
			Write-Verbose -Message 'VM is already running.'
		}

		Write-Verbose -Message 'Finding public IP address of Azure VM...'
		$ip = Get-AzurePublicIp -Vm $vm
		switch ($ConnectionMethod) {
			'RDP' {
				$pw = $Credential.GetNetworkCredential().Password
				$userName = $Credential.Username
				$null = cmdkey /generic:$ip /user:$userName /pass:$pw
				mstsc /v:$ip
			}
			'PSRemoting' {
				if (-not (Wait-WinRm -ComputerName $ip -Credential $Credential)) {
					Write-Error -Message 'PS remoting is not available on VM.'
				} else {
					Write-Verbose -Message 'Connecting to VM via PSRemoting...'
					Enter-PSSession -ComputerName $ip -Authentication CredSSP -Credential $Credential
				}
			}
			default {
				throw "Unrecognized input: [$_]"
			}
		}
	}
}

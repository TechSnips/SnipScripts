<#
	Environment
	===========

	- (2) domain controllers running Windows Server 2016 VMs on the same network
        - TEST-DC
			- techsnips-test.local
        - PROD-DC
			- techsnips.local
	- (2) Enterprise Admin accounts (abertram) in both forests
	- On a Windows 10 workgroup computer using PowerShell Remoting (CredSSP authentication) to connect to both DCs

	Our Mission
	===========
	- Create various trusts between techsnips.local and techsnips-test.local on both sides
	- Test them
	- Remove the trusts
#>

#region Setup work
$prodDcIp = '40.117.38.69'
$prodCred = Get-Credential -UserName 'techsnips.local\abertram' -Message 'Prod'
$testDcIp = '40.121.39.108'
$testCred = Get-Credential -UserName 'techsnips-test.local\abertram' -Message 'Test'

## Create a PowerShell Remoting session on each domain controller to run commands on each
$prodDcSession = New-PSSession -Computer $prodDcIp -Credential $prodCred -Authentication Credssp
$testDcSession = New-PSSession -Computer $testDcIp -Credential $testCred -Authentication Credssp

## Create a configuration array to ease making changes on both DCs
$dcInfo = @(
	@{
		IP = $testDcIp
		Domain = 'techsnips-test.local'
		DNSServer = '10.0.4.100'
		Session = $testDcSession
	}
	@{
		IP = $prodDcIp
		Domain = 'techsnips.local'
		DNSServer = '10.0.4.101'
		Session = $prodDcSession
	}
)
#endregion

#region Set up CredSSP on client and both domain controllers
## https://4sysops.com/archives/using-credssp-for-second-hop-powershell-remoting/

Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value *
Enable-WSManCredSSP -DelegateComputer * -Role Client

foreach ($i in $dcInfo) {
	Invoke-Command -Session $i.Session -ScriptBlock { Enable-WSManCredSSP -Role Server }
}
#endregion

#region Setting up DNS resolution

## Create a conditional forwarder pointing to each others' FQDN. This can be a stub zone too
foreach ($i in $dcInfo) {
	Invoke-Command -Session $i.Session -ScriptBlock { 
		Add-DnsServerConditionalForwarderZone -Name $using:i.Domain -MasterServers $using:i.DNSServer -ReplicationScope Forest
	}
}
#endregion

#region Creating a two-way forest trust on both sides at once

$scriptBlock = {
	$localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
	$strRemoteForest = 'techsnips-test.local'
	$strRemoteUser = 'techsnips-test.local\abertram' ## This is an enterprise admin on the remote side
	$strRemotePassword = 'p@$$w0rd12' 
	$remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest,$strRemoteUser,$strRemotePassword) 
	$remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext) 
	$localForest.CreateTrustRelationship($remoteForest,'Bidirectional') ## Bidirectional, inbound, outbound http://msdn.microsoft.com/en-us/library/system.directoryservices.activedirectory.trustdirection.aspx
}
Invoke-Command -Session $prodDcSession -ScriptBlock $scriptBlock

## Confirm both sides see the trust
foreach ($i in $dcInfo) {
	Invoke-Command -Session $i.Session -ScriptBlock { 
		Get-AdTrust -Filter *
	}
}

## Testing the trust
$trustCheck = { Get-CimInstance -Class Microsoft_DomainTrustStatus -Namespace root\microsoftactivedirectory }
foreach ($i in $dcInfo) {
	Invoke-Command -Session $i.Session -ScriptBlock $trustCheck
}

## Remove the trust
Invoke-Command -Session $prodDcSession -ScriptBlock {  $localForest.DeleteTrustRelationship($remoteForest) }

## Confirm trust is gone on both sides
foreach ($i in $dcInfo) {
	Invoke-Command -Session $i.Session -ScriptBlock { 
		Get-AdTrust -Filter *
	}
}
#endregion

#region Create a two-way trust on one side at a time

## Production
$scriptBlock = {
	$localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
	$strRemoteForest = 'techsnips-test.local'
	$strRemoteUser = 'techsnips-test.local\abertram' ## This is an enterprise admin on the remote side
	$strRemotePassword = 'p@$$w0rd12' 
	$remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest,$strRemoteUser,$strRemotePassword) 
	$remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext) 
	$localForest.CreateLocalSideOfTrustRelationship($strRemoteForest,'Bidirectional',$strRemotePassword)
}
Invoke-Command -Session $prodDcSession -ScriptBlock $scriptBlock

## Confirm trust is created in prod but not in test
Invoke-Command -Session $prodDcSession -ScriptBlock { Get-AdTrust -Filter * }
Invoke-Command -Session $testDcSession -ScriptBlock { Get-AdTrust -Filter * }

## Testing the trust --fails. other side hasn't been created yet
$trustCheck = { Get-CimInstance -Class Microsoft_DomainTrustStatus -Namespace root\microsoftactivedirectory }
Invoke-Command -Session $prodDcSession -ScriptBlock $trustCheck

## Testing
## Create a bidirectional trust on other side
$scriptBlock = {
	$localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
	$strRemoteForest = 'techsnips.local'
	$strRemoteUser = 'techsnips.local\abertram' ## This is an enterprise admin on the remote side
	$strRemotePassword = 'p@$$w0rd12' 
	$remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest,$strRemoteUser,$strRemotePassword) 
	$remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext) 
	$localForest.CreateLocalSideOfTrustRelationship($strRemoteForest,'Bidirectional',$strRemotePassword)
}
Invoke-Command -Session $testDcSession -ScriptBlock $scriptBlock

## Testing the trust --works This may take a second
$trustCheck = { Get-CimInstance -Class Microsoft_DomainTrustStatus -Namespace root\microsoftactivedirectory }
Invoke-Command -Session $prodDcSession -ScriptBlock $trustCheck

## Remove the trusts
Invoke-Command -Session $prodDcSession -ScriptBlock { $localForest.DeleteLocalSideOfTrustRelationship($remoteForest) }
Invoke-Command -Session $testDcSession -ScriptBlock { $localForest.DeleteLocalSideOfTrustRelationship($remoteForest) }

#endregion

#region Clean up our management sessions
$prodDcSession | Remove-PSSession
$testDcSession | Remove-PSSession
#endregion

#region Create functions to speed this up in the future

## The only native AD cmdlet to work with trusts is Get-AdTrust

function New-AdForestTrust {
	[OutputType('pscustomobject')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainController,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RemoteForestName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$SourceDomainControllerCredential,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$DestinationDomainControllerCredential,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Direction = 'Bidirectional',

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$LocalOnly
	)

	$ErrorActionPreference = 'Stop'

	$scriptBlock = {
		$localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
		$strRemoteForest = $using:RemoteForestName
		$strRemoteUser = $using:DestinationDomainControllerCredential.UserName
		$strRemotePassword = ($using:DestinationDomainControllerCredential).GetNetworkCredential().Password
		$remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest,$strRemoteUser,$strRemotePassword) 
		$remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext)
		if ($using:LocalOnly.IsPresent) {
			$localForest.CreateLocalSideOfTrustRelationship($strRemoteForest,'Bidirectional',$strRemotePassword)		
		} else {
			$localForest.CreateTrustRelationship($remoteForest,$using:Direction)
		}
	}

	Invoke-Command -ComputerName $DomainController -Credential $SourceDomainControllerCredential -ScriptBlock $scriptBlock -Authentication Credssp
}

function Remove-AdForestTrust {
	[OutputType('pscustomobject')]
	[CmdletBinding(SupportsShouldProcess)]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainController,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$RemoteForestName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$SourceDomainControllerCredential,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$DestinationDomainControllerCredential,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$LocalOnly
	)

	$ErrorActionPreference = 'Stop'

	$scriptBlock = {
		$localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
		$strRemoteForest = $using:RemoteForestName
		$strRemoteUser = $using:DestinationDomainControllerCredential.UserName
		$strRemotePassword = ($using:DestinationDomainControllerCredential).GetNetworkCredential().Password
		$remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest,$strRemoteUser,$strRemotePassword) 
		$remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext)
		if ($using:LocalOnly.IsPresent) {
			$localForest.DeleteLocalSideOfTrustRelationship($remoteForest)
		} else {
			$localForest.DeleteTrustRelationship($remoteForest)
		}
	}

	Invoke-Command -ComputerName $DomainController -Credential $SourceDomainControllerCredential -ScriptBlock $scriptBlock -Authentication Credssp
}

function Test-AdForestTrust {
	[OutputType('bool')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DomainController,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$TrustedDomain,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)

	$ErrorActionPreference = 'Stop'

	$scriptBlock = {
		if (Get-AdTrust -Filter "Name -eq '$using:TrustedDomain'") {
			$trustStatus = Get-CimInstance -Class Microsoft_DomainTrustStatus -Namespace root\microsoftactivedirectory
			if (-not $trustStatus.TrustStatusString -eq 'OK') {
				throw $trustStatus.TrustStatusString
			} else {
				$true
			}
		} else {
			throw 'The trust does not exist'
		}
	}

	Invoke-Command -ComputerName $DomainController -Credential $Credential -ScriptBlock $scriptBlock -Authentication Credssp
}
#endregion

#region Function demo

## No trusts now so this fails
$testParams = @{
	DomainController = $testDcIp
	TrustedDomain = 'techsnips.local'
	Credential = $testCred
}
Test-AdForestTrust @testParams

## Create one
$newParams = @{
	DomainController = $prodDcIp
	RemoteForestName = 'techsnips-test.local'
	SourceDomainControllerCredential = $prodCred
	DestinationDomainControllerCredential = $testCred
}
New-AdForestTrust @newParams

## Yay! Works now
Test-AdForestTrust @testParams

## Clean it up
$removeParams = @{
	DomainController = $prodDcIp
	RemoteForestName = 'techsnips-test.local'
	SourceDomainControllerCredential = $prodCred
	DestinationDomainControllerCredential = $testCred
}
Remove-AdForestTrust @removeParams
#endregion
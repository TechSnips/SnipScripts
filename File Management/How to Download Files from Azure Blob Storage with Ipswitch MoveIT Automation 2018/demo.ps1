<#
	
	Prerequisites:
		Ipswitch MOVEit Automation 2018 with web admin installed
		Appropriate rights in Autmation
		An Azure storage account
		An Azure service principal setup
	Snip suggestions:
		How to Create and Authenticate to Azure with a Service Principal using PowerShell
	Scenario:
		Run a PowerShell script to download files from a storage container in Azure blob storage
	Notes:
	
#>

#region Step 1: Create PowerShell script to run in MOVEit

## Ensure all errors are terminating errors so they are caught in the catch block
$ErrorActionPreference = 'Stop'

#region Download the AzureRM PowerShell module (if required)
$requiredPowerShellModules = 'AzureRm'

if (-not (Get-Module -Name $requiredPowerShellModules -ListAvailable)) {
	$provParams = @{
		Name           = 'NuGet'
		MinimumVersion = '2.8.5.208'
		Force          = $true
	}

	$null = Install-PackageProvider @provParams
	$null = Import-PackageProvider @provParams

	Install-Module -Name $requiredPowerShellModules -Force -Confirm:$false
}
#endregion

try {
	#region Ensure all of the required task parameters are defined
	$requiredMiParams = 'AzureStorageAccount', 'AzureStorageKey', 'AzureContainer'
	$requiredMiParams | foreach {
		if (-not ($taskParam = $miaclient.MIGetTaskParam($_))) {
			throw "The required Automation task variable [$($_)] was not set."
		}
		Set-Variable -Name $_ -Value $taskParam
	}
	#endregion

	#region Authenticate
	$authCtx = Get-AzureRmContext
	if (-not $authCtx.Environment) {		
		$secpasswd = ConvertTo-SecureString 'p@$$w0rd12' -AsPlainText -Force
		$cred = New-Object System.Management.Automation.PSCredential ('2e40d9cc-dd49-47a8-beb4-2cf98fe8d105', $secpasswd)
		
		Connect-AzureRmAccount -ServicePrincipal -SubscriptionId '86ce8605-317d-4c70-a1e8-e1cdc9d4b0e8' -Tenant 'bb504844-07db-4019-b1c4-7243dfc97121' -Credential $cred
	}
	#endregion
	
	#region Download the file from Azure blob storage
	$ctx = New-AzureStorageContext $AzureStorageAccount $AzureStorageKey
	foreach($filename in (Get-AzureStorageBlob -Container $AzureContainer -Context $ctx | Select-Object -ExpandProperty Name)) {
		$cacheFilename = $miaclient.MINewCacheFilename()
		Get-AzureStorageBlobContent -Blob $filename -Container $AzureContainer -Context $ctx -Destination $cacheFilename
		$miaclient.MIAddFile($cacheFilename, $filename)
	}
	#endregion
} catch {
	## If an exception is thrown, it will end up in here. Let MoveIT know how to handle them
	$miaclient.MISetErrorCode(10000)
	$miaclient.MISetErrorDescription($_.Exception.Message)
}
#endregion

## Step 2: Upload script to MOVEit Automation

start https://localhost/webadmin/#/scripts

## Step 3: Create task

## Step 4: Kick off the task
<#
	
	Prerequisites:
		- Active Directory forest
		- Windows Server 2012R2+ domain controller
		- Remote Server Administration Tools (RSAT) if running on a client computer
	Scenario:
		- Find all previously created GPOs that have a GUID folder in SYSVOL but do not exist
	Notes:
	
#>

function Get-OrphanedGPO {
	<#
	.SYNOPSIS
		This function finds the total number of GPOs in the forest that have a folder on SYSVOL
		but don't have a corresponding GPO to match the GUID.
	.PARAMETER ForestName
		The name of the forest to query
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$ForestName
	)
	try {

		## Find all domains in the forest
		$domains = Get-AdForest -Identity $ForestName | Select-Object -ExpandProperty Domains
		
		$gpoGuids = @()
		$sysvolGuids = @()
		foreach ($domain in $Domains) {
			$gpoGuids += Get-GPO -All -Domain $domain | Select-Object @{ n='GUID'; e = {$_.Id.ToString()}} | Select-Object -ExpandProperty GUID
			foreach ($guid in $gpoGuids) {
				$polPath = "\\$domain\SYSVOL\$domain\Policies"
				$polFolders = Get-ChildItem $polPath -Exclude 'PolicyDefinitions' | Select-Object -ExpandProperty name
				foreach ($folder in $polFolders) {
					$sysvolGuids += $folder -replace '{|}', ''
				}
			}
		}

		Compare-Object -ReferenceObject ($sysvolGuids | Select-Object -Unique) -DifferenceObject ($gpoGuids | Select-Object -Unique) | Select-Object -ExpandProperty InputObject
		
	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	}
}
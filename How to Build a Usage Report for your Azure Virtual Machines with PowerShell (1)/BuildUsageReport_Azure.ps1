<#
	Prerequisites:
		AzureRm.Profile PowerShell module
        AzureRM.UsageAggregates PowerShell module
	Snip Suggestions:
		None
	Notes:
#>

Get-Module AzureRM.Profile
Get-Module AzureRM.UsageAggregates

Connect-AzureRmAccount

#region Basic usage

$params = @{
	ReportedStartTime = '07-10-18'
	ReportedEndTime = '07-18-18'
	AggregationGranularity = 'Hourly'
	ShowDetails = $true
}
$usageData = Get-UsageAggregates @params

$usageData

#endregion

#region Limitations

$usageData.UsageAggregations.Count

$usageData.UsageAggregations | Select-Object -First 10

$usageData.ContinuationToken

#endregion

#region PowerShell wizardry to the rescue!

function Get-AzureUsage {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[datetime]$FromTime,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[datetime]$ToTime,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Hourly','Daily')]
		[string]$Interval = 'Daily'
	)
	
	Write-Verbose -Message 'Querying usage data...'
	$usageData = $null
	do {	
		$params = @{
			ReportedStartTime = $FromTime
			ReportedEndTime = $ToTime
			AggregationGranularity = $Interval
			ShowDetails = $true
		}
		if ((Get-Variable -Name usageData -ErrorAction Ignore) -and $usageData) {
			Write-Verbose -Message "Querying usage data with continuation token $($usageData.ContinuationToken)..."
			$params.ContinuationToken = $usageData.ContinuationToken
		}
		$usageData = Get-UsageAggregates @params
		$usageData.UsageAggregations | Select-Object -ExpandProperty Properties
	} while ('ContinuationToken' -in $usageData.psobject.properties.name -and $usageData.ContinuationToken)
}

$usage = Get-AzureUsage -FromTime '07-01-18' -ToTime '07-19-18' -Interval Hourly -Verbose

$usage.count
#endregion
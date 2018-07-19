Needed Output:


VirtualMachine|Month|Usage|TotalCost


#requireas -Module AzureRm.Biling

function Get-AzureVirtualMachineCost {
	[CmdletBinding()]
	param(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[datetime]$FromTime,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[datetime]$ToTime,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Hourly','Daily')]
		[string]$Interval = 'Daily'
	)
	
	Write-Verbose -Message 'Querying usage data...'
	do {	
		$params = @{
			ReportedStartTime = $FromTime
			ReportedEndTime = $EndTime
			AggregationGranularity = $Interval
			ShowDetails = $true
		}
		if ($usageData) {
			Write-Verbose -Message "Querying usage data with continuation token $($usageData.ContinuationToken)..."
			$params.ContinuationToken = $usageData.ContinuationToken
		}
		$usageData = Get-UsageAggregates @params
		$usageData | Select-Object -ExpandProperty UsageAggregations
	} while ('ContinuationToken' -in $usageData.psobject.properties.name -and $usageData.ContinuationToken)
}



# TODO - Replace the following values

# =================================================

$adTenant = "microsoft.onmicrosoft.com"

# Set well-known client ID for Azure PowerShell

$clientId = "XXXXXXXX-XXXX-4d50-937a-96e123b13015"

# subscription guid

$SubscriptionId = 'XXXXXXXX-XXXX-4802-a5e6-d9c5a43c72a0'

# Set redirect URI for Azure PowerShell

$redirectUri = New-Object System.Uri('https://localhost/')

# Azure on Internal subscription

$OfferDurableId = 'MS-AZR-0121p' # Azure on Internal subscription

# =================================================

 

# Set Resource URI to Azure Service Management API

$resourceAppIdURI = "https://management.azure.com/"

# Set Authority to Azure AD Tenant

$authority = "https://login.microsoftonline.com/$adTenant"

# Create Authentication Context tied to Azure AD Tenant

$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($authority)

# Acquire token

 

$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "Auto")

 

$ResHeaders = @{'authorization' = $authResult.CreateAuthorizationHeader()}

 

$ApiVersion = '2015-06-01-preview'

$Currency = 'USD'

$Locale = 'en-US'

$RegionInfo = 'US'

$File = $env:TEMP + '\resourcecard.json'

$OutputFilename = $env:TEMP + '\ratecardoutput.txt' # This is usually C:\Users\<username>\AppData\Local\Temp

 

$ResourceCard = "https://management.azure.com/subscriptions/{5}/providers/Microsoft.Commerce/RateCard?api-version={0}&`$filter=OfferDurableId eq '{1}' and Currency eq '{2}' and Locale eq '{3}' and RegionInfo eq '{4}'" -f $ApiVersion, $OfferDurableId, $Currency, $Locale, $RegionInfo, $SubscriptionId
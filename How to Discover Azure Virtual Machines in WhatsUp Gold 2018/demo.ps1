<# 
	Prereq snips to follow:
		How to Create and Authenticate to Azure with a Service Principal Using PowerShell

	Assuming the Azure AD application is called TechSnips and you have captured the key when creating it
#>

#region Find the required Azure items to provide to WhatsUp Gold
## Authenticate to Azure
$subscription = Connect-AzureRmAccount -Subscription 'Visual Studio Enterprise: BizSpark'

## Find the tenant ID
$tenantId = $subscription.Context.Tenant.Id

## Find the client ID (WhatsUp term) or the Azure application ID
$adApplication = Get-AzureRmADApplication -DisplayNameStartWith 'TechSnips'
$adApplication
$adApplication.ApplicationId
$clientId = $adApplication.ApplicationId.ToString()
$clientId

## The Azuze AD access key that's only shown when created
$key = 'o2ZXt4i9JHTxdts9P0QZbxQYB8psFjQeoLcpZR9cEp0='
#endregion

#region Create the Azure Credential in WhatsUp Gold
# http://localhost/NmConsole/#discover/p=%7B%22fullScreen%22%3Atrue%7D

#endregion


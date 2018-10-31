## Prereqs
## the AzureRm PowerShell modules
## Install-Module AzureRm

## Authenticate to your Azure subscription with the interactive prompt
Connect-AzureRmAccount -Subscription 'Visual Studio Premium with MSDN'

## Note the subscription and tenant IDs. We'll need those later. If you forget, you can always use Get-AzureRmASubscription.

#region Create the Azure AD application
$secPassword = ConvertTo-SecureString -AsPlainText -Force -String 'PowerShell r0cks!'
$myApp = New-AzureRmADApplication -DisplayName TechSnips -IdentifierUris 'http://www.techsnips.io' -Password $secPassword
$myApp
#endregion

#region Create the service principal referencing the application created
$sp = New-AzureRmADServicePrincipal -ApplicationId $myApp.ApplicationId
$sp
#endregion

#region Assign a role to the service principal
New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ServicePrincipalNames[0]
#endregion

#region Authenticating with Add-AzureRmAccount
$subscription = Get-AzureRmSubscription -SubscriptionName 'Visual Studio Premium with MSDN'
$appCred = Get-Credential -UserName $myApp.ApplicationId -Message 'Azure AD Cred'
Connect-AzureRmAccount -ServicePrincipal -SubscriptionId $subscription.SubscriptionId -Tenant $subscription.TenantId -Credential $appCred
#endregion
$creds = Get-Credential
Connect-MsolService -Credential $creds

#TenantId
$tenantId = "<YOUR_TENANT_ID>"

#Create the domain in Azure AD
New-MsolDomain -TenantId $tenantId -Name "<YOUR_DOMAIN_NAME>"

#Get TXT value
Get-MsolDomainVerificationDns -TenantId $tenantId -DomainName "<YOUR_DOMAIN_NAME>"

#Add TXT value to registrar
## Go to YOUR registrar ##

#Confirm creation of TXT in registrar
nslookup -type=TXT <YOUR_DOMAIN_NAME>

#Verify you own the domain (for O365)
Confirm-MsolDomain -TenantId $tenantId -DomainName "<YOUR_DOMAIN_NAME>"

#Check if that worked ??
Get-MsolDomain -TenantId $tenantId -DomainName "<YOUR_DOMAIN_NAME>"

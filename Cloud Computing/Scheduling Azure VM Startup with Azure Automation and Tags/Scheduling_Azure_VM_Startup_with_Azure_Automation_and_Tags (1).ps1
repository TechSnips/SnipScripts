
$Conn = Get-AutomationConnection -Name AzureRunAsConnection

Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$VMs = Get-AzureRMVM | where {$_.Tags.Values -like '*6amStart*'} 

$VMs | Start-AzureRMVM

Write-Output $VMs.Name
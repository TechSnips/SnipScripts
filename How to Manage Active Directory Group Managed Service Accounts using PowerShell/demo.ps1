<#
	Environment
	===========
	- techsnips.local forest
        - PROD-DC
	- Enterprise Admin accounts (abertram)
	- On a Windows 10 workgroup computer using PowerShell Remoting to connect to DC

	Our Mission
	===========
	- Create, install, enumerate, test, install and uninstall managed service accounts (MSAs)
	- Install the gMSA on a domain-joined computer called CLIENT-PROD

	Prereqs
	=========
	CredSSP configured on Windows 10 computer
	RSAT installed on the computer associated with the gMSA
#>

#region Setup work
$dcIp = 'x.x.x.x'
$domainCred = Get-Credential -UserName 'techsnips.local\abertram' -Message 'Domain Controller'

Enter-PSSession -Computer $dcIp -Credential $domainCred
#endregion

#region KDS root key

## Check for an existing KDS root key
Get-KdsRootKey

# quick way to get this done instead of waiting up to 10 hours
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))

## Command for production
# Add-KdsRootKey -EffectiveImmediately

## Test to ensure it's working
Test-KdsRootKey -KeyId (Get-KdsRootKey).KeyId

#endregion

#region Creating gMSAs

## Check for any existing gMSAs
Get-ADServiceAccount -Filter *

## Find the computer account the gMSA will be associated
$gMsaHost = Get-AdComputer -Identity 'CLIENT-PROD'

$msaName = 'lobService'
$params = @{
	Name = $msaName
	DNSHostName = 'lobService.techsnips.local'
	PrincipalsAllowedToRetrieveManagedPassword = $gMsaHost
	Enabled = $true
	# ServicePrincipalNames = @('http/www', 'http/www.contoso.com')
	# OtherAttributes @{ 'msDS-AllowedToDelegateTo' = 'http/backend' } ## Optional --to enable constrained delegation https://technet.microsoft.com/en-us/library/jj553400
}
New-AdServiceAccount @params
Get-ADServiceAccount -Filter *
#endregion

#region Associate the new MSA with a target computer in Active Directory

Add-ADComputerServiceAccount -Identity $gMsaHost -ServiceAccount $msaName
Get-ADComputerServiceAccount -Identity $gMsaHost

#endregion

#region Ensure the following prereqs are on the computer that's going to be using the MSA
# ## This verifies that the computer is eligible to host the gMSA, retrieves the credentials and stores the account information on the local computer

## Let's disconnect from the domain controller PSSession now and go into the client
$clientIp = 'x.x.x.x'
Enter-PSSession -ComputerName $clientIp -Credential $domainCred -Authentication Credssp

Install-ADServiceAccount -Identity 'lobService'

#endregion

#region Testing the MSA

Test-ADServiceAccount 'lobService'

#endregion

#region Run services under your MSA

## Create a dummy service

$serviceName = 'testservice'
New-Service -Name $serviceName -BinaryPathName "C:\WINDOWS\System32\svchost.exe -k netsvcs"

## Assign the gMSA to the service
$service = Get-Wmiobject Win32_Service -Filter "name='$serviceName'"
$invParams = $service.psbase.getMethodParameters('Change') 
$invParams['StartName'] = 'techsnips.local\lobService$'
$invParams['StartPassword'] = $null
$service.InvokeMethod('Change',$invParams,$null)

Get-CimInstance -ClassName Win32_Service -Filter "name='$serviceName'" -Property StartName | Select-Object -Property StartName

#endregion

#region Removing a MSA

## Optionally, remove the service account from Active Directory. You can skip this step if you just want to reassign an existing MSA from one computer to another.

Remove-ADComputerServiceAccount –Identity (Get-AdComputer -Identity 'CLIENT-PROD') -ServiceAccount 'lobService'

## Remove the MSA

Remove-ADServiceAccount –Identity 'lobService'

#endregion
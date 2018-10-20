<#
	
	Prerequisites:
		- Active Directory with a Windows Server 2012 R2 or later domain controller
		- Windows Server 2012 R2 domain functional level
		- Remote Server Administration Tools (RSAT) installed which includes the ActiveDirectory PowerShell module
		- At least one computer account, user account and service account
	Scenario:
		- Create authentication policies for users, computers and service accounts
		- Create authentication policy silos
	Notes:
		SDDLS - https://itconnect.uw.edu/wares/msinf/other-help/understanding-sddl-syntax/
		Authentication policies - https://docs.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/authentication-policies-and-authentication-policy-silos
#>

#region Enabling dynamic access control

<# Open the GMPC and navigate to the Default Domain Controllers Policy
	
	Computer Configuration | Administrative Templates | System | KDC

	Setting: Key Distribution Center (KDC) client support for claims, compound authentication and Kerberos armoring

	Setting
		- Enabled
		- Options - Always provide claims
#>

#endregion

#region Authentication policies

#region Creating authentication policies

#region Getting necessary SDDLs

## Define the computers that high-privileges users, other computers and service accounts will be allowed to authenticate from and to
$highPrivilegeComputerAccountAuthFrom = 'techsnips.local\CLIENT-PROD$'
$highPrivilegeComputerAccountAuthTo = 'techsnips.local\PROD-DC$'

## Define high-privilege users
$highPrivilegeUserAccount = 'techsnips.local\mrceo'

## Create a dummy text file
$dummyFile = 'C:\dummy.txt'
New-Item -Path $dummyFile -Value ''

## Assign any permission to a computer. We'll query this for the device in a minute
$acl = Get-Acl -Path $dummyFile
$computerPerm = $highPrivilegeComputerAccountAuthFrom, 'Read', 'Allow' 
$computerRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $computerPerm
$acl.SetAccessRule($computerRule) 

$authFromSddl = $acl.sddl

$acl = Get-Acl -Path $dummyFile
$computerPerm = $highPrivilegeComputerAccountAuthTo, 'Read', 'Allow' 
$computerRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $computerPerm
$acl.SetAccessRule($computerRule) 

$authToSddl = $acl.sddl

$authFromSddl
$authToSddl

#endregion

#region Create the computer authentication policies

$computerAuditOnlyPolicyName = 'LockItDown-AuditOnly-Computers'
$computerEnforcedPolicyName = 'LockItDown-Enforced-Computers'
$parameters = @{
	ComputerAllowedToAuthenticateTo = $authToSddl
	ComputerTGTLifetimeMins         = 60
}
New-ADAuthenticationPolicy @parameters -Name $computerAuditOnlyPolicyName -Description 'Audit only policy - Computers'
New-ADAuthenticationPolicy @parameters -Name $computerEnforcedPolicyName -Description 'Enforced policy - Computers'

#endregion

#region Create the user authentication policies

$userAuditOnlyPolicyName = 'LockItDown-AuditOnly-Users'
$userEnforcedPolicyName = 'LockItDown-Enforced-Users'
$parameters = @{
	UserAllowedToAuthenticateTo   = $authToSddl
	UserTGTLifetimeMins           = 60
	UserAllowedToAuthenticateFrom = $authFromSddl
}
New-ADAuthenticationPolicy @parameters -Name $userAuditOnlyPolicyName -Description 'Audit only policy - Users'
New-ADAuthenticationPolicy @parameters -Name $userEnforcedPolicyName -Description 'Enforced policy - Users'

#endregion

#region Create the service account authentication policies

$serviceAuditOnlyPolicyName = 'LockItDown-AuditOnly-Services'
$serviceEnforcedPolicyName = 'LockItDown-Enforced-Services'
$parameters = @{
	ServiceAllowedToAuthenticateTo   = $authToSddl
	ServiceTGTLifetimeMins           = 60
	ServiceAllowedToAuthenticateFrom = $authFromSddl
}
New-ADAuthenticationPolicy @parameters -Name $serviceAuditOnlyPolicyName -Description 'Audit only policy - Services'
New-ADAuthenticationPolicy @parameters -Name $serviceEnforcedPolicyName -Description 'Enforced policy - Services'

#endregion

## Confirm the authentication policies were created
Get-ADAuthenticationPolicy -Filter "Name -like 'LockItDown*'" | Select-Object -Property Name

## Changing
Set-ADAuthenticationPolicy -Identity 'LockItDown-AuditOnly-Users' -Description 'some description'

## Removing
Get-ADAuthenticationPolicy -Filter "Name -like 'LockItDown*'" | Remove-ADAuthenticationPolicy

#endregion

#endregion

#region Silos

#region Creating silos

#region Audit-only authentication policy silo and assigning policies

$parameters = @{
	ComputerAuthenticationPolicy = (Get-ADAuthenticationPolicy -Identity 'LockItDown-AuditOnly-Computers')
	ServiceAuthenticationPolicy  = (Get-ADAuthenticationPolicy -Identity 'LockItDown-AuditOnly-Services')
	UserAuthenticationPolicy     = (Get-ADAuthenticationPolicy -Identity 'LockItDown-AuditOnly-Users')
	Description                  = 'User,Computer and Service Account Auditing Silo'
	Name                         = 'AuditingSilo'
}
New-ADAuthenticationPolicySilo @parameters

#endregion

#region Enforced authentication policy silo and assigning policies

$parameters = @{
	ComputerAuthenticationPolicy = (Get-ADAuthenticationPolicy -Identity 'LockItDown-Enforced-Computers')
	ServiceAuthenticationPolicy  = (Get-ADAuthenticationPolicy -Identity 'LockItDown-Enforced-Services')
	UserAuthenticationPolicy     = (Get-ADAuthenticationPolicy -Identity 'LockItDown-Enforced-Users')
	Description                  = 'User,Computer and Service Account Enforced Silo'
	Name                         = 'EnforcedSilo'
}
New-ADAuthenticationPolicySilo @parameters

#endregion

#endregion

## Granting and revoking access to silos
Grant-ADAuthenticationPolicySiloAccess -Identity 'AuditingSilo' -Account 'abertram'
Revoke-ADAuthenticationPolicySiloAccess -Identity 'AuditingSilo' -Account 'abertram'

## Changing
Set-ADAuthenticationPolicySilo -Identity 'AuditingSilo' -Description 'some description'

## Removing
Get-ADAuthenticationPolicySilo | Remove-ADAuthenticationPolicySilo

#endregion
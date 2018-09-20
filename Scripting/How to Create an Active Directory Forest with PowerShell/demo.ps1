<#
	Environment
	===========

	- (2) Windows Server 2016 VMs on the same network (soon-to-be domain controllers)
        - TEST-DC
            - static IP of 10.0.4.101
            - DNS server address set to 10.0.4.101,10.0.4.100
        - PROD-DC
            - static IP of 10.0.4.100
            - DNS server address set to 10.0.4.101,10.0.4.100
	- (1) Windows 10 computer in workgroup (I'm on this now)

	Our Mission
	===========

	- Create an Active Directory forest on the TEST-DC VM called techsnips-test.local
	- Create an Active Directory forest on the PROD-DC VM called techsnips.local
	- Create a PowerShell function to ease forest creation
    
#>

#region Setting up the test forest

$testDcIp = ''
$serverCredential = Get-Credential

## Connect to a Windows Server 2016 VM
Enter-PSSession -ComputerName $testDcIp -Credential $serverCredential

## We could also just use the -ComputerName parameter on Install-WindowsFeature
Install-windowsfeature -Name AD-Domain-Services

$safeModePw = ConvertTo-SecureString -String 'p@$$w0rd10' -AsPlainText -Force

$forestParams = @{
	DomainName                    = 'techsnips-test.local'
	InstallDns                    = $true
	Confirm                       = $false
	SafeModeAdministratorPassword = $safeModePw
	WarningAction                 = 'Ignore'
}
Install-ADDSForest @forestParams

## Reach out to the newly-christened test domain controller
Invoke-Command -ComputerName $testDcIp -ScriptBlock { Get-AdForest } -Credential $serverCredential

#endregion

#region Creating a custom function
function New-ActiveDirectoryForest {
	param(
		[Parameter(Mandatory)]
		[string]$Name,

		[Parameter(Mandatory)]
		[pscredential]$Credential,

		[Parameter(Mandatory)]
		[string]$SafeModePassword,

		[Parameter(Mandatory)]
		[string]$ComputerName
	)

	Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {

		Install-windowsfeature -Name AD-Domain-Services
		
		$forestParams = @{
			DomainName                    = $using:Name
			InstallDns                    = $true
			Confirm                       = $false
			SafeModeAdministratorPassword = (ConvertTo-SecureString -AsPlainText -String $using:SafeModePassword -Force)
			WarningAction                 = 'Ignore'
		}
		$null = Install-ADDSForest @forestParams
	}
}
#endregion

#region Setting up the production forest
$prodDcIp = '40.117.38.69'
$forestParams = @{
    ComputerName = $prodDcIp
    Name = 'techsnips.local'
    Credential = $serverCredential
    SafeModePassword = 'p@$$w0rd10'
}
New-ActiveDirectoryForest @forestParams

## Reach out to the newly-christened production domain controller
Invoke-Command -ComputerName $prodDcIp -ScriptBlock { Get-AdForest } -Credential $serverCredential

#endregion
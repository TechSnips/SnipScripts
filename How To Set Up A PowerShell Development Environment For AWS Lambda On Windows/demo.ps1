<#
	
	Prerequisites:
		- Windows 10 or later (will work on Windows Server as well)
		- An Internet connection
		
	Scenario:
		Complete local setup to begin creating AWS Lambda functions for invoking PowerShell scripts
	Notes:
		Installing PowerShell Core on Windows: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-windows?view=powershell-6
		.NET SDK Install script: https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

#>

#region Install PowerShell Core v6+

## Download and install the MSI from the GitHub page

## Via PowerShell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$installerFilePath = "$env:TEMP\PSCore61.msi"
Invoke-WebRequest -Uri 'https://github.com/PowerShell/PowerShell/releases/download/v6.1.0/PowerShell-6.1.0-win-x64.msi' -OutFile $installerFilePath

$procParams = @{
	FilePath     = 'msiexec.exe'
	ArgumentList = @('/i', "`"$installerFilePath`"", '/qb')
	Wait         = $true
	NoNewWindow  = $true
}
Start-Process @procParams

## Via github.com
## https://github.com/PowerShell/PowerShell/releases

#endregion

#region Install .NET Core 2.1 SDK

## Via PowerShell

## Download the installer script
$installerFilePath = "$env:TEMP\dotnet-install.ps1"
Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile $installerFilePath

## Install the latest .NET SDK long-term-supported
& $installerFilePath -Channel LTS

## Via microsoft.com
## https://www.microsoft.com/net/download

#endregion

#region Install the AWSLambdaPSCore module

## Bring up PowerShell Core you just downloaded and installed

## Download and install the AWSLambdaPSCore module from the PowerShell Gallery
Install-Module AWSLambdaPSCore -Scope CurrentUser

#endregion
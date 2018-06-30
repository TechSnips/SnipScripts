## Prereqs -- must have PowerShell remoting enabled
## We're in a domain environment.

## Simple command
Invoke-Command -ScriptBlock { Get-Service -Name wuauserv } -ComputerName SRV1

## Passing local variables to remote sessions
$serviceName = 'wuauserv'
Invoke-Command -ScriptBlock { Get-Service -Name $args[0] } -ComputerName SRV1 -ArgumentList $serviceName
Invoke-Command -ScriptBlock { Get-Service -Name $using:serviceName } -ComputerName SRV1

## Reading local scripts and running them remotely
Set-Content -Path C:\GetService.ps1 -Value 'Get-Service -Name wuauserv'
Invoke-Command -ComputerName SRV1 -FilePath C:\GetService.ps1

## Multiple computers at once
Invoke-Command -ComputerName SRV1, SRV2, SRV3 -FilePath C:\GetService.ps1

## Multiple computers at once using background jobs
Invoke-Command -ComputerName SRV1, SRV2, SRV3 -FilePath C:\GetService.ps1 -AsJob
Get-Job
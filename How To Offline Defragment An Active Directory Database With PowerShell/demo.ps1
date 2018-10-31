<#
	
	Prerequisites:
		- Active Directory on a Windows Server 2008+ DC
	Environment:
		- RDPed to the domain controller with the AD database
		- Logged onto the domain controller with the Directory Service Restore Mode administrator account 
	Notes:
	
#>

Stop-Service -DisplayName 'Active Directory Domain Services' -Force

## Perform the defragmentation
$tempDbFolder = $env:TEMP
ntdsutil "activate instance ntds" "files" "compact to $tempDbFolder" q q

## Find the path of the AD database
$dbPath = (Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\NTDS\Parameters).'DSA Database File'

## Make a backup of the old DB
Copy-Item -Path $dbPath -Destination 'C:\ntdsdit.backup'

## Overwrite the old database
Copy-Item "$tempDbFolder\ntds.dit" $dbPath

## Remove old log files
Remove-Item -Path 'C:\Windows\NTDS\*.log'

## Start AD back up
Start-Service -DisplayName 'Active Directory Domain Services'
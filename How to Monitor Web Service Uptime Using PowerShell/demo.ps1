<#
	
	Prerequisites:
		PowerShell!
		A web service of some kind
	Snip suggestions:
		HOW TO USE ALL THE BELLS AND WHISTLES WITH POWERSHELL'S TEST-CONNECTION AND TEST-NETCONNECTION CMDLETS
	Scenario:
		Create a PowerShell script that tests whether a page is accessible. If not, logs to a file. Then, create
		a scheduled task on a remote server in my Active Directory environmentto kick it off every day.
	Notes:
	
#>

#region Create the testing script
ise C:\Users\TechSnips\Documents\Test-WebService.ps1
& 'C:\Users\TechSnips.TECHSNIPS\Documents\Test-WebService.ps1' -Url 'http://www.techsnips.io/contributor-signup'

Get-Content -Path 'C:\WebServiceMonitor.log'
#endregion

#region Create the scheduled task

## Using the New-ScheduledScript in the PowerShell Gallery
Install-Script New-ScheduledScript -Force

#region Verify no scheduled task
Invoke-Command -ComputerName TSDC -ScriptBlock { Get-ScheduledTask -TaskName 'Web Service Monitor' }
#endregion

$parameters = @{
	ScriptFilePath = 'C:\Users\techsnips.TECHSNIPS\Documents\Test-WebService.ps1'
	LocalScriptFolderPath = 'C:\'
	TaskTriggerOptions = @{
		'Daily' = $true
		'At' = '3Am'
	}
	TaskName = 'Web Service Monitor'
	TaskRunAsUser = 'techsnips.local\techsnips'
	TaskRunAsPassword = 'I like azure.'
	Computername = 'tsdc.techsnips.local'
    ScriptParameters = "-Url http://www.techsnips.io"
}
New-ScheduledScript.ps1 @parameters
#endregion

#region Verify the scheduled task has been created
Invoke-Command -ComputerName TSDC -ScriptBlock { Get-ScheduledTask -TaskName 'Web Service Monitor' }
#endregion

#region Kick off the scheduled task manually on TSDC
Invoke-Command -ComputerName TSDC -ScriptBlock { Start-ScheduledTask -TaskName 'Web Service Monitor' }
#endregion

#region Confirm the log file is being written to
Get-Content -Path '\\TSDC\c$\WebServiceMonitor.log'
#endregion
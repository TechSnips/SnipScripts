<#
	
	Prerequisites:
		Ipswitch MOVEit Automation 2018 with web admin installed
		Appropriate rights in Autmation
	Snip suggestions:
		
	Scenario:
		When a file is dropped into a monitored folder, run a PowerShell script to log an activity
	Notes:
	
#>

## Step 1: Create PowerShell script to run in MOVEit

$logMessage = $miaclient.MIGetTaskParam('Message')
Add-Content -Path 'C:\activity.log' -Value $logMessage

## Step 2: Upload script to MOVEit Automation

start https://localhost/webadmin/#/scripts

## Step 3: Create task to monitor a folder


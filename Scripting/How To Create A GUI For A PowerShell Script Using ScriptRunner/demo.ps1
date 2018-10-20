<#
	
	Prerequisites:
		AppShere's ScriptRunner installed and configured on a Windows server
		Remote Server Administration Tools (RSAT) installed on local computer
		Logged into ScriptRunner
		A CSV file placed in a known location on a remote server (or local)
		
	Scenario:
		We need to set up a way for HR to easily import a list of new employees from a CSV file
	
	Environment:
		Running ScriptRunner 2018 on a Windows Server 2016 VM
	
#>

## Verify the users I'm going to be creating aren't created yet
'jbradley', 'bsmith', 'jwest' | Get-AdUser

## Show the CSV file
Import-Csv 'C:\Users\abertram\Desktop\Employees.csv'

## Show the PowerShell script in other ISE tab

## switch over to web interface
start 'http://scriptrunner01.techsnips.local/scriptrunner/admin/'

## Provide password to TechSnips AD Admin Credential
## Credentials --> TechSnips AD Admin

## Assign Credential to Target
## Targets --> AD Local

## Upload the script to ScriptRunner
## Scripts | Cmdlets --> Create

## Settings --> ScriptRunner Library to show location
Start-Process 'C:\ProgramData\AppSphere\ScriptMgr\_UPLOAD_'

## Create action
## Actions --> Create

## Verify the users are created and added to the groups
'jbradley', 'bsmith', 'jwest' | Get-AdUser -Properties memberOf | Select-Object -Property name, givenName, surName, memberOf
## Scenario: An evolution of a logging function

#region Function basics

## no workie
Write-Log

## No parameters -- simplest as possible
function Write-Log {
	[CmdletBinding()]
	param()
}

## Copying/pasting text into the console loads the function into my session

## works now but nothing happens. The function executed though.
Write-Log

## Let's add some code for the function to actually do something
function Write-Log {
	[CmdletBinding()]
	param()
    
	'I did something'
}

## ran the code inside of the function
Write-Log
#endregion

#region Getting input to your functions --parameters
function Write-Log {
	[CmdletBinding()]
	param($Message)
    
	$Message
}

Write-Log -Message 'I did something'

function Write-Log {
	[CmdletBinding()]
	param($Message, $Severity)
    
	"$Message - Severity: $Severity"
}

Write-Log -Message 'I did something' -Severity 1
#endregion

#region Specifying parameter types --limits to only a specific type
function Write-Log {
	[CmdletBinding()]
	param([System.ServiceProcess.ServiceController]$Message)
    
	$Message
}

## no workie
Write-Log -Message $false

## workie
$service = Get-Service | Select -First 1
Write-Log -Message $service

#endregion

#region Using parameter attributes
function Write-Log {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$Message,
        
		[Parameter()]
		[int]$Severity = 1
	)
    
	"$Message - Severity: $Severity"
    
}

## prompts for Message
Write-Log

#endregion

#region Using parameter validation
function Write-Log {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[pscustomobject]$Message,
        
		[Parameter()]
		[ValidateRange(1, 5)]
		[int]$Severity
	)
    
	"$Message - Severity: $Severity"
    
}

## no workie
Write-Log -Message 'I did something' -Severity 8

## workie
Write-Log -Message 'I did something' -Severity 5

## Search for "parameter attribute" on techsnips.io
#endregion
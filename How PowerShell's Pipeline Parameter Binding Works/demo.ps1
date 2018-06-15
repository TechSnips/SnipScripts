Function Get-Something {
	[CmdletBinding()]
	Param(
		$item
	)
	Write-Host "You passed the parameter value $item into the function"
}

'PowerShell is Awesome!' | Get-Something


## Must use the Parameter() keyword
Function Get-Something {
	[CmdletBinding()]
	Param(
		[Parameter()]
		$item
	)
	Write-Host "You passed the parameter value $item into the function"
}

'PowerShell is Awesome!' | Get-Something

#region Binding via property name
Function Get-Something {
	[CmdletBinding()]
	Param(
		[Parameter(ValueFromPipelineByPropertyName)]
		$item
	)
	Write-Host "You passed the parameter value $item into the function"
}

## No properties named item
Get-Service -Name wuauserv | Select-Object -Property *

## will not work. The object type is not correct
Get-Service -Name wuauserv | Get-Something

## The parameter name must match the name of the property exactly
Function Get-Something {
	[CmdletBinding()]
	Param(
		[Parameter(ValueFromPipelineByPropertyName)]
		$Name
	)
	Write-Host "You passed the parameter value $Name into the function"
}

Get-Service -Name wuauserv | Get-Something
#endregion

#region Binding via object
Function Get-Something {
	[CmdletBinding()]
	Param(
		[Parameter(ValueFromPipeline)]
		[System.ServiceProcess.ServiceController]$Service
	)
	Write-Host "You passed the parameter value $($Service.Name) into the function"
}

Get-Service -Name wuauserv | Get-Something
#endregion
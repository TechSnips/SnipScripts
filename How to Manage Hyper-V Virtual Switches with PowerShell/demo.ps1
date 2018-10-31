<#
	
	Prerequisites:
		- Hyper-V host
	Snip suggestions:
		N/A
	Notes:
	
#>

#region Remote to the Hyper-V Host
$computerName = '13.68.140.191'
$credential = Get-Credential
Enter-PSSession -ComputerName $computerName -Credential $credential
#endregion

## Can use External, Internal, Private
New-VMSwitch -Name PowerLaboops -SwitchType Internal

Rename-VMSwitch -Name PowerLaboops -NewName PowerLab2

Get-VmSwitch -Name PowerLab2
Get-VmSwitch -Name PowerLab2 | Remove-VMSwitch -Force
Get-VmSwitch -Name PowerLab2

## Handy function
function New-LabSwitch {
	param(
		[Parameter(Mandatory)]
		[string]$Name,

		[Parameter()]
		[string]$Type = 'External'
	)

	if (-not (Get-VmSwitch -Name $Name -SwitchType $Type -ErrorAction SilentlyContinue)) {
		Write-Verbose -Message "Creating switch [$Name]..."
        $null = New-VMSwitch -Name $Name -SwitchType $Type
        Write-Verbose -Message 'Switch created.'
	} else {
		Write-Verbose -Message "The switch [$($Name)] has already been created."
	}
}

New-LabSwitch -Name PowerLab -Type Internal -Verbose
#endregion
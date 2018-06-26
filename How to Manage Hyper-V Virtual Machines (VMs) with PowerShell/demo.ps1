<#
	
	Prerequisites:
		- Hyper-V Host
		- Hyper-V switch created
	Snip suggestions:
		- How to Manage Hyper-V Switches in PowerShell
		- How to Manage Hyper-V Virtual Disks (VHDs) in PowerShell
	Notes:
	
#>

#region Creating a simple VM
Get-Help New-VM -Detailed
New-VM -Name 'SRV1' -Path 'C:\PowerLab\VMs' -MemoryStartupBytes 2GB -Switch 'PowerLab' -Generation 2
Get-Vm -Name SRV1 | Select-Object -Property *
#endregion

#region Creating a VM with a VHD in one shot
$parameters = @{
	Name               = 'SRV2'
	Path               = 'C:\PowerLab\VMs'
	MemoryStartupBytes = 4GB
	Switch             = 'PowerLab'
	Generation         = 2
	NewVhdPath         = 'C:\PowerLab\VHDs\SRV2.vhdx'
	NewVHDSizeBytes    = 20GB
}
New-VM @parameters
Get-Vm -Name SRV2
Get-VM -Name SRV2 | Get-VMHardDiskDrive
#endregion

#region Other VM actions

Get-Command -Noun VM -Module Hyper-V

$vm = Get-VM -Name SRV2

## Changing various attribute of the VM
Get-Help Set-Vm -Detailed
$vm | Set-VM -AutomaticStopAction Shutdown
$vm | Set-VM -ProcessorCount 2 -DynamicMemory

## Stopping/starting the VM
$vm | Stop-VM -Force

$vm | Start-VM
($vm | Get-VM).State
($vm | Get-VM).State

$vm | Stop-VM -Force

$vm | Start-VM -Passthru | Wait-Vm -For Heartbeat -Timeout 20

$vm | Restart-Vm -Force -Passthru

$vm | Suspend-VM
$vm
$vm | Resume-VM
$vm

## Creating snapshots (checkpoints) and restoring
$vm | Checkpoint-VM
$vm | Get-VMCheckpoint
$vm | Get-VMCheckpoint -Name 'SRV2 - (6/26/2018 - 4:52:04 PM)' | Restore-VMCheckpoint -Confirm:$false

## Exporting/importing VMs
$vm | Export-Vm -Path 'C:\VMExports'
Get-ChildItem -Path 'C:\VMExports\SRV2'

$vm | Remove-VM
$vm | Stop-Vm -Force -Passthru | Remove-VM -Force
Get-VM -Name SRV2
Get-ChildItem -Path 'C:\VMExports\SRV2'

Import-vm -Path 'C:\VMExports\SRV2\Virtual Machines\780EC369-5086-4B7E-880F-00303F63474E.vmcx'
Get-VM -Name SRV2

#endregion

## Handy function
function New-LabVm {
	param(
		[Parameter(Mandatory)]
		[string]$Name,

		[Parameter()]
		[string]$Path = 'C:\PowerLab\VMs',

		[Parameter()]
		[string]$Memory = 4GB,

		[Parameter()]
		[string]$Switch = 'PowerLab',

		[Parameter()]
		[ValidateRange(1, 2)]
		[int]$Generation = 2,

		[Parameter()]
		[switch]$PassThru
	)

	if (-not (Get-Vm -Name $Name -ErrorAction SilentlyContinue)) {
		$null = New-VM -Name $Name -Path $Path -MemoryStartupBytes $Memory -Switch $Switch -Generation $Generation
	} else {
		Write-Verbose -Message "The VM [$($Name)] has already been created."
	}
	if ($PassThru.IsPresent) {
		Get-VM -Name $Name
	}
}

New-LabVm -Name 'SRV3' -Verbose
#endregion
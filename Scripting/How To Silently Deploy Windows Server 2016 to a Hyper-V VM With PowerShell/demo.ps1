<#
	
	Prerequisites:
		- An ISO file containing the bits for the OS
		- A Hyper-V host
	Snip suggestions:
		N/A
    Notes:
		I'm on my Hyper-V host now.
		Ensure to add our own Windows Server product key to the LABDC.XML answer file
#>

#region Create the Hyper-V VM
New-VM -Name LABDC -Path 'C:\PowerLab\VMs' -MemoryStartupBytes 4GB -Switch 'PowerLab' -Generation 2
#endregion

#region The answer file

## Create one from scratch or use the Windows Answer File Generator
# http://www.windowsafg.com/

<# 
	We'll use one I've already built, it:

	- Creates two NTFS partitions (100MB and all the rest labled System Reserve and OS)
	- Set Windows organization to "Automate the Boring Stuff with PowerShell"
	- locale to en-US
	- ComputerName to LABDC
	- No AutoActivate
	- Sets static IP
	- Sets primary DNS 
	- Sets DNS domain
	- Enables dynamic DNS
	- Changes administrator password to P@$$w0rd12
	- Creates local LabUser account
	- Sets autologon to login with username LabUser and password P@$$w0rd12
	- Disables all firewall profiles
	- Sets network location to Work
	- Sets timezone to CST

Available in SnipScripts (LABDC.xml)
#>

#endregion

#region Convert the ISO to a VHDX

## Download the Convert-WindowsImage.ps1 script
# https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f

## Dot-source the script to make the Convert-WindowsImage function available
. 'C:\Convert-WindowsImage.ps1'

## Define all of the parameters to use for the conversion
$convertParams = @{
	SourcePath        = 'C:\PowerLab\ISOs\en_windows_server_2016_vl_x64_dvd_11636701.iso'
	SizeBytes         = 40GB
	Edition           = 'ServerStandardCore'
	VHDFormat         = 'VHDX'
	VHDPath           = 'C:\PowerLab\VHDs\LABDC.vhdx'
	VHDType           = 'Dynamic'
	VHDPartitionStyle = 'GPT'
	UnattendPath      = 'C:\LABDC.xml'
}

## Perform the conversion which creates the VHDX
Convert-WindowsImage @convertParams
#endregion

#region Attach the VHDX to the VM and set it as the first boot priority
$vm = Get-Vm -Name 'LABDC'
$vm | Add-VMHardDiskDrive -Path 'C:\PowerLab\VHDs\LABDC.vhdx'
$bootOrder = ($vm | Get-VMFirmware).Bootorder
if ($bootOrder[0].BootType -ne 'Drive') {
	$vm | Set-VMFirmware -FirstBootDevice $vm.HardDrives[0]
}
#endregion

## Boot up the VM and cross your fingers!
<#
	
	Prerequisites:
		- A Hyper-V host
	Snip suggestions:
		N/A
	Notes:
	
#>

#region Creating VHDs
Get-Help New-Vhd -Detailed
Test-Path -Path 'C:\PowerLab\VHDs\MYVM.vhdx'
New-Vhd -Path 'C:\PowerLab\VHDs\MYVM-50.vhdx' -SizeBytes 50GB -Dynamic
New-Vhd -Path 'C:\PowerLab\VHDs\MYVM-10.vhdx' -SizeBytes 10GB -Dynamic
Test-Path -Path 'C:\PowerLab\VHDs\MYVM-10.vhdx'

## Diff disks
New-VHD -Path 'C:\PowerLab\VHDs\MYVM-Diff.vhdx' -ParentPath 'C:\PowerLab\VHDs\MYVM-50.vhdx' -Differencing
New-VHD -Path 'C:\PowerLab\VHDs\MYVM-Diff-Child.vhdx' -ParentPath 'C:\PowerLab\VHDs\MYVM-Diff.vhdx' -Differencing

#endregion

#region Inspecting existing VHDs
Get-Vhd -Path 'C:\PowerLab\VHDs\MYVM-Diff.vhdx'

#endregion

#region Modifying existing VHDs

## Setting sector size
Set-VHD -Path 'C:\PowerLab\VHDs\MYVM-50.vhdx' -PhysicalSectorSizeBytes 512

## Find the diff disk's parent path
Get-VHD -Path 'C:\PowerLab\VHDs\MYVM-Diff.vhdx' | Select-Object -ExpandProperty ParentPath

function Get-DiffDiskParent {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)

    if ($parentPath = Get-VHD -Path $Path | Select-Object -ExpandProperty ParentPath) {
        $parentPath
	    while($parentPath = Get-VHD -Path $parentPath | Select-Object -ExpandProperty ParentPath) {
		    $parentPath
	    }
    }
}

Get-DiffDiskParent -Path 'C:\PowerLab\VHDs\MYVM-Diff-Child.vhdx'

#endregion

#region Assigning a VHD to the VM
Get-VM -Name SRV1 | Add-VMHardDiskDrive -Path 'C:\PowerLab\VHDs\MYVM-50.vhdx'
Get-VM -Name SRV1 | Get-VMHardDiskDrive
#endregion

#region Removing VHDs

## Detach the VHD from the VM
Get-VM -Name SRV1 | Get-VMHardDiskDrive | Remove-VMHardDiskDrive

## Remove the VHD from disk
Remove-Item -Path C:\PowerLab\VHDs\foo.vhdx

#endregion

#region Creating handy functions
function New-LabVhd {
	param
	(
		[Parameter(Mandatory)]
		[string]$Name,

		[Parameter()]
		[string]$AttachToVm,

		[Parameter()]
		[ValidateRange(512MB, 1TB)]
		[int64]$Size = 50GB,

		[Parameter()]
		[ValidateSet('Dynamic', 'Fixed')]
		[string]$Sizing = 'Dynamic',

		[Parameter()]
		[string]$Path = 'C:\PowerLab\VHDs'
	)

	$vhdxFileName = "$Name.vhdx"
	$vhdxFilePath = Join-Path -Path $Path -ChildPath "$Name.vhdx"

	### Ensure we don't try to create a VHD when there's already one there
	if (-not (Test-Path -Path $vhdxFilePath -PathType Leaf)) {
		$params = @{
			SizeBytes = $Size
			Path      = $vhdxFilePath
		}
		if ($Sizing -eq 'Dynamic') {
			$params.Dynamic = $true
		} elseif ($Sizing -eq 'Fixed') {
			$params.Fixed = $true
		}

		New-VHD @params
		Write-Verbose -Message "Created new VHD at path [$($vhdxFilePath)]"
	}

	### Attach either the newly created VHD or the one that was already there to the VM.
	if ($PSBoundParameters.ContainsKey('AttachToVm')) {
		if (-not ($vm = Get-VM -Name $AttachToVm -ErrorAction SilentlyContinue)) {
			Write-Warning -Message "The VM [$($AttachToVm)] does not exist. Unable to attach VHD."
		} elseif (-not ($vm | Get-VMHardDiskDrive | Where-Object { $_.Path -eq $vhdxFilePath })) {
			$vm | Add-VMHardDiskDrive -Path $vhdxFilePath
			Write-Verbose -Message "Attached VHDX [$($vhdxFilePath)] to VM [$($AttachToVM)]."
		} else {
			Write-Verbose -Message "VHDX [$($vhdxFilePath)] already attached to VM [$($AttachToVM)]."
		}
	}
}

New-LabVhd -Name MYVMVHD -Verbose -AttachToVm SRV1

Get-VM -Name SRV1 | Get-VMHardDiskDrive | Remove-VMHardDiskDrive
New-LabVhd -Name MYVMVHD -Verbose -AttachToVm SRV1

 
#endregion
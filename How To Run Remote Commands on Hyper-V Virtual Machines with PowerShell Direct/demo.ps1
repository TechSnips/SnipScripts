<#
	
	Prerequisites:
		Windows Server 2016 or Windows 10 Hyper-V host
		PowerShell console launched as administrator
		Running PowerShell as a Hyper-V Administrator
		VM must be on the local Hyper-V host
		VM must be Windows 10 or Windows Server 2016

	Snip suggestions:
		N/A
	
#>

#region Hyper-V host is remote so we'll use "regular" remoting to get into it
$hyperVHost = '23.96.10.116'
$hyperVHostCred = Get-Credential
Enter-PSSession -ComputerName $hyperVHost -Credential $hyperVHostCred

## The VMs on our host
Get-Vm
#endregion

#region Typical PowerShell Remoting
$vmName = 'SRV1'
$vmCred = Get-Credential
Invoke-Command -ComputerName $vmName -ScriptBlock { hostname } -Credential $vmCred
#endregion

#region PowerShell Direct
Invoke-Command -VMName $vmName -ScriptBlock { hostname } -Credential $vmCred

## Find the VM guid
$vm = Get-Vm -Name SRV1
$vm.Guid

Invoke-Command -VMName $vm.Guid -ScriptBlock { hostname } -Credential $vmCred
#endregion
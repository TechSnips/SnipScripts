<#
	
	Prerequisites:
		Windows Server 2016 or Windows 10 Hyper-V host
		PowerShell console launched as administrator
		Running PowerShell as a Hyper-V Administrator
		VM must be on the local Hyper-V host
		VM must be Windows 10 or Windows Server 2016

	Snip suggestions:
		N/A

    Notes:
        I am currently working from a machine outside of the Hyper-V host
	
#>

#region Hyper-V host is remote so we'll use "regular" remoting to get into it
$hyperVHost = '40.76.212.105'
$hyperVHostCred = Get-Credential
Enter-PSSession -ComputerName $hyperVHost -Credential $hyperVHostCred

## The VMs on our host
Get-Vm
#endregion

#region Typical PowerShell Remoting --failure
## PowerShell remoting works great when it works but you've got dependencies like DNS, IP, authentication, etc
$vmName = 'LABDC'
$vmCred = Get-Credential -UserName 'LabUser' -Message 'user'
Invoke-Command -ComputerName $vmName -ScriptBlock { hostname } -Credential $vmCred

## Now let's try from the Hyper-V host itself
#endregion

#region Disable the NIC on the VM (from the Hyper-V host) This kills our PowerShell remoting session
Invoke-Command -ComputerName $vmName -ScriptBlock {Get-NetAdapter | Disable-NetAdapter} -Credential $vmCred
ping labdc
#endregion

#region PowerShell Direct --from my computer remoted into they Hyper-V host
Invoke-Command -VMName $vmName -ScriptBlock { hostname } -Credential $vmCred

## Find the VM guid
$vm = Get-Vm -Name LABDC
$vmId = $vm.Id.ToString()
$vmId

Invoke-Command -VMID $vmId -ScriptBlock { hostname } -Credential $vmCred
#endregion
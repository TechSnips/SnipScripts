# Prerequisities - HyperV Host of Win10, Server 2016, or Server 2019
# Check if the Hyper-V Integration Service is enabled on the VM
Get-VMIntegrationService -Name 'Guest Service Interface' -VMName TechSnips-Demo


# Enabling this VM Integration Service
Enable-VMIntegrationService -Name 'Guest Service Interface' -VMName TechSnips-Demo


# Confirm NO Network connection / NIC (Hyper-V Settings)
$DemoVM = Get-VM TechSnips-Demo
$DemoVM.NetworkAdapters


# Connecting to VM via PowerShell Direct
$mySession = New-PSSession -VMName TechSnips-Demo -Credential "dk\david"
Enter-PSSession -Session $mySession
Exit-PSSession

# Copying files OUT of the VM to the Host (VM  ->  Hypervisor host)
Copy-Item -FromSession $mySession -Path C:\MyAppLogs\My_Demo_App_logfile.log -Destination C:\_Arrives_FromVM\


# Show that Host now contains the file we needed out of the VM!
Get-ChildItem C:\_Arrives_FromVM\


# Copying files into the VM from the Host (Hypervisor host  ->  VM)
Copy-VMFile -vm $DemoVM -SourcePath "C:\_Arrives_FromHost\wallpaper.png" -DestinationPath "C:\_TechSnips_NEW\VM_Folder1\wallpaper.png" -FileSource Host  -CreateFullPath

Enter-PSSession $mySession

Get-ChildItem C:\_TechSnips_NEW\VM_Folder1\

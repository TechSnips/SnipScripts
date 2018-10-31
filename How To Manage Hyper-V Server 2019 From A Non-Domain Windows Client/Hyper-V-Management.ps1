<#Prerequisites

    Client
    - Windows 10 Pro or Enterprise
    - Hyper-V Manager Installed
    - Windows PowerShell 5.1
    - Hyper-V PowerShell Module
    
    Server
    - Hyper-V Server 2019

#>

#Attempt PowerShell Remoting
Enter-PSSession -ComputerName titan.frozennorth.ad

#Add an entry to the hosts file for the host's fqdn
Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"
Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.2.5 titan.frozennorth.ad"

#Set Adapter Connection to Private
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private

#Configure PowerShell Remoting
Enable-PSRemoting

#Add the entire domain for delegation (Handy if you have more than one Host)
Get-WSManCredSSP
Enable-WSManCredSSP -Role Client -DelegateComputer "*.frozennorth.ad"

#Add all hosts in the entire domain to the Trusted Hosts (Handy if you have more than one Host)
Get-Item -Path WSMan:\localhost\Client\TrustedHosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "*.frozennorth.ad"

#Add credentials for each computer
cmdkey /list
cmdkey /add:titan.frozennorth.ad /user:Administrator /pass:P@ssw0rd

#Verify PowerShell Remoting is operational
Enter-PSSession -ComputerName titan.frozennorth.ad


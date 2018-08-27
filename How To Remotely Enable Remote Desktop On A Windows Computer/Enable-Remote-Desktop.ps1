Invoke-Command -ComputerName vs220-fs -ScriptBlock {
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0}

Invoke-Command -ComputerName vs220-fs -ScriptBlock {
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'}
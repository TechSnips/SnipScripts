#Region NetTCPIP module
Get-command -Module NetTCPIP
#EndRegion 

#Region TestNetConnection common usage
# CommonTCPPort: SMB, HTTP, RDP, WINRM
# InformationLevel: Quiet / Detailed
Test-NetConnection -ComputerName localhost -CommonTCPPort HTTP -InformationLevel Detailed
#endregion

#Region Checks if a port is open on a target host
$Target = "10.0.0.10"
$Port = "1433"
Test-NetConnection -computername $Target -Port $Port -InformationLevel Quiet
#endregion

#Region Checks different ports
$Target = "10.0.0.10"
$ports = 21..25
$ports | foreach-object {Test-NetConnection -computername $Target -Port $_ -InformationLevel Quiet}
#endregion

#Region Imports our scan-computer function with dot sourcing
. .\scan-computer.ps1
#endregion

#Region First example with a target host and a predefined list of ports
$Target = "10.0.0.10" #Read-Host "Please provide the Target IP"
Scan-Computer -ComputerName $Target -Ports (80, 443, 1433, 3389) 
#endregion

#Region Second example with a port range
$Ports = 1430..1440 
$Target = "10.0.0.10"
Scan-Computer -ComputerName $Target -Ports $Ports 
#endregion
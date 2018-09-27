<#

Further Reading:
    
    Win32_PingStatus class - For more options to use
    https://msdn.microsoft.com/en-us/library/aa394350(v=vs.85).aspx

    Test-Connection Cmdlet
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-connection?view=powershell-6

    Test-NetConnection
    https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps
#>



Invoke-Expression -Command "Ping.exe google.com"



Test-Connection www.google.com

Test-Connection www.google.com -Count 2 -BufferSize 128 -Delay 3

Test-Connection -Source "LocalHost", "TestVM02", "TestVM03" -ComputerName "www.google.com"

Test-Connection www.google.com -Quiet

if (Test-Connection www.google.com -Quiet) { Write-Output "Good Google"}



Test-Connection google.com -count 10 -AsJob

Get-Job | Receive-Job




Test-NetConnection www.google.com

Test-NetConnection www.google.com -Port 80

Test-NetConnection www.google.com -TraceRoute

Test-NetConnection www.google.com -InformationLevel Quiet

Test-NetConnection www.google.com | select *



Get-WmiObject -Class Win32_PingStatus -Filter 'Address = "www.google.com" or Address = "www.yahoo.com"'

Get-WmiObject -Class Win32_PingStatus -Filter 'address = "www.google.com" and buffersize = 128'

Get-WmiObject -Class Win32_PingStatus -Filter 'address = "www.google.com" and buffersize = 128' | select *






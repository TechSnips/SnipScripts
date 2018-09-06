Get-Content "C:\Program Files (x86)\Jenkins\secrets\initialAdminPassword" | clip

Write-Output "The hostname of this machine is $env:ComputerName"
New-Item -path c:\test -ItemType Directory
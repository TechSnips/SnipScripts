$html = @()

$html += Get-Service -Name BITS | select Name,DisplayName,StartType,Status | ConvertTo-Html -As Table -Fragment -PreContent '<h1>BITS Service</h1>'

$html += Get-Service -Name WinRM | select Name,DisplayName,StartType,Status | ConvertTo-Html -As Table -Fragment -PreContent '<h1>WINRM Service</h1>' -PostContent '<i>This is the Post Content<i>'

$html | Out-File .\service.html

start .\service.html
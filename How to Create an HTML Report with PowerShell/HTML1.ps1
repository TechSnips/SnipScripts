Get-Service -Name BITS

$html = Get-Service -Name BITS | select Name,DisplayName,StartType,Status | ConvertTo-Html -As Table -Fragment -PreContent "<h1>BITS Service</h1>"


#region Output File

$html | Out-File .\service.html

start .\service.html

#endregion
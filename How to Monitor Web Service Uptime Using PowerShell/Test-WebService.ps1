param(
	[Parameter(Mandatory)]
	[ValidateNotNullOrEmpty()]
	[string]$Url,

	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$LogFilePath = 'C:\WebServiceMonitor.log'
)

## Parse host from URL
$hostname = $url.split('/')[2]

## Ensure HTTP is up
$now = Get-Date -Format 'MM-dd-yyyy hh:mm:ss'
if (-not (Test-NetConnection -ComputerName $hostname -CommonTCPPort HTTP).TcpTestSucceeded) { 
	Add-Content -Path $LogFilePath -Value "$now - Host [$hostname] is not responding on port 80."
} else {
	Add-Content -Path $LogFilePath -Value "$now - Host [$hostname] is OK."
	$response = Invoke-WebRequest -Uri $url -UseBasicParsing
	if ($response.StatusCode -ne 200) {
		Add-Content -Path $LogFilePath -Value "$now - Page [$Url] is broken. HTTP response code was [$($response.StatusCode)]."
	} else {
		Add-Content -Path $LogFilePath -Value "$now - Page [$Url] OK."
	}
}
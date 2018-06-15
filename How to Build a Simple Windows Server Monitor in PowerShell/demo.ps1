## Bring all of the server names into memory
$servers = Import-Csv -Path 'C:\Servers.csv'
$servers

## Run the Get-Service command on each server
Import-Csv -Path 'C:\Servers.csv' | Get-Service -Name wuauserv

Import-Csv -Path 'C:\Servers.csv' | ForEach-Object {
	if (Test-Connection -Computer $_.ComputerName -Quiet -Count 1) {
        $_.ComputerName
    } else {
        Write-Host "The server [($($_.ComputerName)] was offine"
    }
}

## Perform an action if the service is stopped
Import-Csv -Path 'C:\Servers.csv' | ForEach-Object {
    if (Test-Connection -Computer $_.ComputerName -Quiet -Count 1) {
        $serviceStatus = Get-Service -Name wuauserv -ComputerName $_.ComputerName
        if ($serviceStatus.Status -eq 'Stopped') {
		    Write-Host "The [$($serviceStatus.Name)] service on [$($serviceStatus.MachineName)] is not started! Attempting to start..."
		    $serviceStatus | Start-Service
	    } else {
		    Write-Host "The [$($serviceStatus.Name)] service on [$($serviceStatus.MachineName)] is already started."
	    }
    } else {
        Write-Host "The server [($($_.ComputerName)] was offline"
    }
}
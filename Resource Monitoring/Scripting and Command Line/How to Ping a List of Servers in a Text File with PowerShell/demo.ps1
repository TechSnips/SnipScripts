## Start with a text file full of server names
Set-Content -Path C:\Servers.txt -Value 'SRV1', 'SRV2', 'localhost', 'SRV3'

## ..or use a CSV. The data source doesn't matter
Set-Content -Path C:\Servers.txt -Value 'ServerName'
Add-Content -Path C:\Servers.txt -Value 'SRV1', 'SRV2', 'localhost', 'SRV3'

## Read the servers to create an array to work with each element
$servers = Get-Content -Path C:\Servers.txt
$servers = Import-Csv -Path C:\Servers.txt | Select-Object -ExpandProperty ServerName
$servers

## A foreach loop is perfect because we want to perform an action on EACH item
foreach ($server in $servers) {
	Test-Connection -ComputerName $server -Count 1 -Quiet
}

## Let's pretty up the output by creating own own object
foreach ($server in $servers) {
	[pscustomobject]@{
		ServerName = $server
		IsOnline   = (Test-Connection -ComputerName $server -Count 1 -Quiet)
	}
}

## Once we create our own object, we can add just about anything we need here
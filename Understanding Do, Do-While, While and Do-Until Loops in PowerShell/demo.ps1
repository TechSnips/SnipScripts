

#region That's one way to do it
Test-Connection -ComputerName SERVER1
Test-Connection -ComputerName SERVER2
Test-Connection -ComputerName SERVER3
Test-Connection -ComputerName SERVER4
Test-Connection -ComputerName SERVER5
#endregion

#region Cut down on the extra code. Use the DRY method with a foreach loop
foreach ($server in @('SERVER1', 'SERVER2', 'SERVER3', 'SERVER4', 'SERVER5')) {
	Test-Connection -ComputerName $server
}
#endregion

#region Notice repeated calls to Add-Content
Add-Content -Path 'C:\Folder\file.txt' -Value 'somevalue'
Add-Content -Path 'C:\Program Files\Folder2\file.txt' -Value 'somevalue'
Add-Content -Path 'C:\Folder3\file.txt' -Value 'somevalue'
#endregion

#region Simplify code by defining all of the unique elements, creating an array and using foreach
$paths = @('C:\Folder\file.txt', 'C:\Program Files\Folder2\file.txt', 'C:\Folder3\file.txt')

foreach ($i in $paths) {

}

foreach ($i in $paths) {
	Add-Content -Path $i -Value 'somevalue'
}

ForEach-Object -InputObject $paths -Process {Add-Content -Path $_ -Value 'somevalue'}

$paths.foreach({ Add-Content -Path $_ -Value 'somevalue' })
#endregion

#region For loops
Write-Host 1
Write-Host 2
Write-Host 3
Write-Host 4
Write-Host 5

for ($i = 1; $i -lt 6; $i++) {
	Write-Host $i
}
#endregion

#region Do/While/Until loops

## Continually try to start a service _while_ it's stopped
do {
	Start-Service -Name problemservice -ComputerName SRV1
} while ((Get-Service -Name problemservice -ComputerName SRV1).Status -eq 'Stopped')

## This does the same thing as the do loop just doesn't try to start it the first time
while ((Get-Service -Name problemservice -ComputerName SRV1).Status -eq 'Stopped') {
	Start-Service -Name problemservice -ComputerName SRV1
}

## This attempts to start the service _until_ it's running. Opposite of above.
do {
	Start-Service -Name problemservice -ComputerName SRV1
} until ((Get-Service -Name problemservice -ComputerName SRV1).Status -eq 'Running')
#endregion

#region Performing an action on multiple servers at once with conditional logic
$servers = Get-Content -Path C:\Servers.txt

foreach ($server in $servers) {
	if (-not (Test-Connection -ComputerName $server -Count 1)) {
		Write-Host "The server $server is offline!" -ForegroundColor Red
	} else {
		Write-Host "The server $server is online." -ForegroundColor Green
	}
}
#endregion
#region Do loops -- always perform an action once and check condition last

## Continually try to start a service _while_ it's stopped
do {
	Start-Service -Name wuauserv
} while ((Get-Service -Name wuauserv).Status -eq 'Stopped')
#endregion

#region While loops -- Check condition first and run action last

## This does the same thing as the do loop just doesn't try to start it the first time
while ((Get-Service -Name wuauserv).Status -eq 'Running') {
	Start-Service -Name wuauserv
}
#endregion

#region Do/Until Loop

## This attempts to start the service _until_ it's running. Opposite of above.
do {
	Stop-Service -Name wuauserv
} until ((Get-Service -Name wuauserv).Status -eq 'Stopped')

#endregion
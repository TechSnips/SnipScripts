Get-Service -DisplayName Xbox*
Get-Service -DisplayName Xbox* | Out-GridView -PassThru | Start-Service
Get-Service -DisplayName Xbox* | Out-GridView -PassThru | Stop-Service
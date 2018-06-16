### [ Adjusts Script Execution-Policy to Remote-Signed in order to run the installation script ]

Set-ExecutionPolicy RemoteSigned


### [ Boxstarter Installation Script ]

. { Invoke-WebRequest -useb http://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; get-boxstarter -Force


### [ Invoke-WebRequest was not introduced until Powershell v3 ] 
### [ Boxstarter Installation Script for PowerShell v2 using Invoke-Expression and .Net Class ]

iex ((New-ObjectSystem.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force

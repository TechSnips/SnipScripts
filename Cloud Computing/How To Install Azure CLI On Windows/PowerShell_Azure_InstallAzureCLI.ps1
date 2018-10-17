# Docs: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest

# Set the download location
$DownloadFile = 'C:\Users\Anthony\Downloads\AzureCLI.msi'

# Download the file
Invoke-WebRequest 'https://aka.ms/installazurecliwindows' -OutFile $DownloadFile

# Run the installer
Start-Process msiexec.exe -Wait -ArgumentList "/i $DownloadFile /qn /L*v log.txt"

# Login
Start-Process PowerShell.exe
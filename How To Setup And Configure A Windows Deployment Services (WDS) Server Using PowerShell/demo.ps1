Install-WindowsFeature wds-deployment -includemanagementtools

$wdsUtilResults = wdsutil /initialize-server /remInst:"E:\remInstall"
$wdsUtilResults | select -last 1

# Import the WinPE image from your install media
Import-WdsBootImage -Path "D:\sources\boot.wim" 

# Create an install image group and import the images
New-WdsInstallImageGroup -Name "desktops" 

# Identify the Image Names used for the Wim on your install media
Get-WindowsImage -imagePath "D:\sources\install.wim" | select Imagename

$imageName = 'Windows 10 Pro'
Import-WdsInstallImage -ImageGroup "desktops" -Path "D:\sources\install.wim" -ImageName $imageName

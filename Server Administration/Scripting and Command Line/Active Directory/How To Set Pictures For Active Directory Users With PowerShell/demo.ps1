<#
	
	Prerequisites:
		- Active Directory domain
		- A Windows Server 2012 domain controller or later
		- Remote Server Administration Tools (RSAT) package installed
		- At least one Active Directory user without a thumbnail picture set.
	Scenario:
		- Working on a Windows 10 computer joined to the domain with users to update
		- Logged in as a member of the Domain Admins group
		- Find a user photo, resize it to fit recommended dimensions and set it for an AD user
	Notes:
	
#>

## Find a picture to use (use your own obvious if you have it)

$imagePath = 'C:\YouSexyBeastYou.png'
$imageUrl = 'https://res.cloudinary.com/techsnips/image/upload/v1534018774/Contributor_Images/Adam_Bertram.png'
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

Get-item -path $imagePath

## Resize it to recommended dimensions (96x96px)

## Using a slightly modified community script by Christopher Walker
## https://gist.github.com/someshinyobject/617bf00556bc43af87cd

. Resize-Image.ps1

Resize-Image -Width 96 -ImagePath $imagePath -MaintainRatio -NewImagePath 'C:\sexy.png'
$imagePath = 'C:\sexy.png'

Get-item -path $imagePath

## Encode the image into byte format
$photoInBytes = [byte[]](Get-Content $imagePath -Encoding Byte)

## Find the AD user's thumbnail first
$adUser = Get-ADUser -Identity 'abertram' -Properties thumbnailPhoto

## Set the thumbnail
Set-ADUser -Identity 'abertram' -Replace @{thumbnailPhoto = $photoInBytes}

Get-ADUser -Identity 'abertram' -Properties thumbnailPhoto | Select-Object -Property thumbnailPhoto

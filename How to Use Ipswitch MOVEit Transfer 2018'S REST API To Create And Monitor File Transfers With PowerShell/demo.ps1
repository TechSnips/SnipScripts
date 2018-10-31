<#
	
	Prerequisites:
		Ipswitch MOVEit Transfer 2018
		Permissions to query MOVEit Transfer
		Files already added to Transfer and accessible to your user
	Snip suggestions:
		
	Scenario:

		- File wallpaper.png already uploaded to the /Home/TechSnips/SourceFolder folder in Transfer
		- Need to move wallpaper.png to /Home/TechSnips/DestinationFolder which is already created

	References:

		https://docs.ipswitch.com/MOVEit/Transfer2018SP1/api/rest/#_postapi_v1_files_id_copy-1_0
	
#>

#region Authenticate to MOVEit Transfer by obtaining an access token

## Craft the endpoint URI
$serverName = 'localhost'
$userName = 'techsnips'
$password = 'f7d6su'
$grantType = 'password'

$authEndpointUrl = "https://$serverName/api/v1/token"
$authHttpBody = "grant_type=$grantType&username=$userName&password=$password"

## Send the HTTP POST request to MOVEit
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$token = Invoke-RestMethod  -Uri $authEndpointUrl -Method 'POST' -Body $authHttpBody
$token = $token.access_token
#endregion

## Prep headers to be passed later
$headers = @{ 'Authorization' = "Bearer $token" }

## Find the file id of the wallpaper.png file
start 'http://localhost/human.aspx?r=549867013&arg06=497832098&arg12=filelist'
$endpointUrl = "https://$serverName/api/v1/files"
$file = (Invoke-RestMethod -Headers $headers -Uri $endpointUrl).items | Where-Object {$_.name -eq 'wallpaper.png'}
$file

## Make sure we can see the destination folder and get the folder ID
$endpointUrl = "https://$serverName/api/v1/folders"
$folder = (Invoke-RestMethod -Headers $headers -Uri $endpointUrl).items | Where-Object {$_.name -eq 'DestinationFolder'}
$folder

## Copy file to DestinationFolder fodler
$folder = @{
    destinationFolderId = $folder.id
}
$json = $folder | ConvertTo-Json
$endpointUrl = "https://$serverName/api/v1/files/$($file.Id)/copy"
Invoke-RestMethod -Method POST -Headers $headers -Uri $endpointUrl -Body $json -ContentType 'application/json'

## Browse to the destination folder in the web UI
start 'http://localhost/human.aspx?r=1274902781&arg06=497853955&arg12=filelist'

#region Build a PowerShell tool

function Copy-MOVEitTransferFile {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SourceFilePath,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$DestinationFolderPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$UserName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Password,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ServerName = 'localhost'
	)

	$authEndpointUrl = "https://$ServerName/api/v1/token"
	$authHttpBody = "grant_type=password&username=$UserName&password=$Password"

	## Send the HTTP POST request to MOVEit
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
	$token = Invoke-RestMethod  -Uri $authEndpointUrl -Method 'POST' -Body $authHttpBody
	$token = $token.access_token
	#endregion

	## Prep headers to be passed later
	$headers = @{ 'Authorization' = "Bearer $token" }

	## Find the file id of the wallpaper.png file
	$endpointUrl = "https://$ServerName/api/v1/files"
	$allFiles = (Invoke-RestMethod -Headers $headers -Uri $endpointUrl).items
	$filePath = $SourceFilePath | Split-Path -Parent
	$fileName = $SourceFilePath | Split-Path -Leaf
	if (-not ($file = $allFiles| Where-Object { $_.path -eq $SourceFilePath })) {
		throw "The file at path [$($SourceFilePath)] was not found on the MOVEit Transfer server."
	}

	## Make sure we can see the destination folder and get the folder ID
	$endpointUrl = "https://$ServerName/api/v1/folders"
	$allFolders = (Invoke-RestMethod -Headers $headers -Uri $endpointUrl).items
	if (-not ($folder = $allFolders | Where-Object {$_.path -eq $DestinationFolderPath})) {
		throw "The folder [$($DestinationFolderPath)] was not found on the MOVEit Transfer server."
	}

	## Copy file to DestinationFolder fodler
	$folder = @{
		destinationFolderId = $folder.id
	}
	$json = $folder | ConvertTo-Json
	$endpointUrl = "https://$ServerName/api/v1/files/$($file.Id)/copy"
	Invoke-RestMethod -Method POST -Headers $headers -Uri $endpointUrl -Body $json -ContentType 'application/json'
}

$params = @{
	SourceFilePath = '/Home/techsnips/SourceFolder/wallpaper.png'
	DestinationFolderPath = '/Home/techsnips/DestinationFolder'
	UserName = 'techsnips'
	Password = 'f7d6su'
}
Copy-MOVEitTransferFile @params

## Try it again
Copy-MOVEitTransferFile @params
#endregion
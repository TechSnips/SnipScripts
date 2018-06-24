<#

	Snip suggestions:

	- STORING ENCRYPTED POWERSHELL CREDENTIALS ON DISK

	Notes:

	- This only works while running under the same user account (DPAPI) https://msdn.microsoft.com/en-us/library/ms995355.aspx

#>

#region Encrypting a plain text string
$plainTexPassword = 'p@$$w0rd12'

$secureString = $plainTexPassword | ConvertTo-SecureString
$secureString = $plainTexPassword | ConvertTo-SecureString -Force
$secureString = $plainTexPassword | ConvertTo-SecureString -Force -AsPlainText 
$secureString
#endregion

#region Saving the encrypted password to disk
$secureString | Export-Clixml -Path C:\EncryptedPassword.xml
#endregion

#region Reading the encrypted string
Get-Content -Path C:\EncryptedPassword.xml
$secureString = Import-Clixml -Path C:\EncryptedPassword.xml
$secureString

[System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($securestring))
#endregion

#region Real-world functions
function Save-Password {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$PlainTextPassword,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$FilePath
	)

	$PlainTextPassword | Protect-Password | Export-Clixml -Path $FilePath

}

function Get-Password {
	[OutputType('string')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$FilePath
	)

	Import-Clixml -Path $FilePath | Unprotect-Password
	

}

function Protect-Password {
	[OutputType('securestring')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[string]$PlainTextPassword	
	)

	process {
		$PlainTextPassword | ConvertTo-SecureString -Force -AsPlainText 
	}
	
}

function Unprotect-Password {
	[OutputType('string')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[securestring]$SecurePassword
	)

	process {
		[System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecurePassword))
	}
}

Save-Password -PlainTextPassword 'password123' -FilePath C:\pwd.xml
Get-Password -FilePath C:\pwd.xml
#endregion
<#
.SYNOPSIS
   Resizes an JPG, PNG or BMP image.
.DESCRIPTION
   Resize an image based on a new given height or width or a single dimension and a maintain ratio flag. 
   The execution of this CmdLet creates a new file named "OriginalName_resized" and maintains the original
   file extension
.PARAMETER Width
   The new width of the image. Can be given alone with the MaintainRatio flag
.PARAMETER Height
   The new height of the image. Can be given alone with the MaintainRatio flag
.PARAMETER ImagePath
   The path to the image being resized
.PARAMETER NewImagePath
	The path to the image that has been resized.
.PARAMETER MaintainRatio
   Maintain the ratio of the image by setting either width or height. Setting both width and height and also this parameter
   results in an error
.PARAMETER Percentage
   Resize the image *to* the size given in this parameter. It's imperative to know that this does not resize by the percentage but to the percentage of
   the image.
.PARAMETER SmoothingMode
   Sets the smoothing mode. Default is HighQuality.
.PARAMETER InterpolationMode
   Sets the interpolation mode. Default is HighQualityBicubic.
.PARAMETER PixelOffsetMode
   Sets the pixel offset mode. Default is HighQuality.
.PARAMETER PassThru
	To optionally return the image file when complete.
.EXAMPLE
   Resize-Image -Height 45 -Width 45 -ImagePath "Path/to/image.jpg"
.EXAMPLE
   Resize-Image -Height 45 -MaintainRatio -ImagePath "Path/to/image.jpg"
.EXAMPLE
   #Resize to 50% of the given image
   Resize-Image -Percentage 50 -ImagePath "Path/to/image.jpg"
.NOTES
   Originally Written By: 
   Christopher Walker
   URL: https://gist.github.com/someshinyobject/617bf00556bc43af87cd
#>
Function Resize-Image() {
	[CmdLetBinding( SupportsShouldProcess, ConfirmImpact='Medium', DefaultParameterSetName='Absolute')]
	Param (
		[Parameter(Mandatory)]
		[string]$ImagePath,

		[Parameter(Mandatory)]
		[string]$NewImagePath,

		[Parameter()]
		[switch]$MaintainRatio,

		[Parameter(ParameterSetName='Absolute')]
		[int]$Height,

		[Parameter(ParameterSetName='Absolute')]
		[int]$Width,

		[Parameter(ParameterSetName='Percent')]
		[int]$Percentage,
		
		[Parameter()]
		[string]$SmoothingMode = 'HighQuality',

		[Parameter()]
		[string]$InterpolationMode = 'HighQualityBicubic',

		[Parameter()]
		[string]$PixelOffsetMode = 'HighQuality'
	)
	Begin {
		If ($Width -and $Height -and $MaintainRatio.IsPresent) {
			throw "Absolute Width and Height cannot be given with the MaintainRatio parameter."
		}
 
		If (($Width -xor $Height) -and (-not $MaintainRatio.IsPresent)) {
			throw "MaintainRatio must be set with incomplete size parameters (Missing height or width without MaintainRatio)"
		}
 
		If ($Percentage -and $MaintainRatio.IsPresent) {
			Write-Warning "The MaintainRatio flag while using the Percentage parameter does nothing"
		}

		if ([System.IO.Path]::GetExtension($ImagePath) -ne [System.IO.Path]::GetExtension($NewImagePath)) {
			throw 'The resized image must be of the same type as the original'
		}

		Add-Type -AssemblyName 'System.Drawing'
	}
	Process {

		try {
			$path = (Resolve-Path $ImagePath).Path
			
			$originalImage = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $path
			
			if ($MaintainRatio.IsPresent) {
				if ($Height) {
					$Width = $originalImage.Width / $originalImage.Height * $Height
				}
				if ($Width) {
					$Height = $originalImage.Height / $originalImage.Width * $Width
				}
			}

			if ($Percentage) {
				$product = $Percentage / 100
				$Height = $originalImage.Height * $product
				$Width = $originalImage.Width * $product
			}

			$bitmap = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $Width, $Height
			$resizedImage = [System.Drawing.Graphics]::FromImage($bitmap)
			
			#Retrieving the best quality possible
			$resizedImage.SmoothingMode = $SmoothingMode
			$resizedImage.InterpolationMode = $InterpolationMode
			$resizedImage.PixelOffsetMode = $PixelOffsetMode
			$resizedImage.DrawImage($originalImage, $(New-Object -TypeName System.Drawing.Rectangle -ArgumentList 0, 0, $Width, $Height))

			if ($PSCmdlet.ShouldProcess("Resized image $path", "Save to $NewImagePath")) {
				$bitmap.Save($NewImagePath)
			}
		} catch {
			$PSCmdlet.ThrowTerminatingError($_)
		} finally {
			if (Get-Variable -Name 'bitmap' -ErrorAction 'Ignore') {
				$bitmap.Dispose()
			}
			if (Get-Variable -Name 'resizedImage' -ErrorAction 'Ignore') {
				$resizedImage.Dispose()
			}
		}
	}
}
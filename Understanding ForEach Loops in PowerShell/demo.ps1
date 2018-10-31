#region Bad, bad! DRY (Don't Repeat Yourself)
Add-Content -Path 'C:\Folder\file.txt' -Value 'somevalue'
Add-Content -Path 'C:\Program Files\Folder2\file.txt' -Value 'somevalue'
Add-Content -Path 'C:\Folder3\file.txt' -Value 'somevalue'
#endregion

## Define all of the items that have to change in an array
$paths = @('C:\Folder\file.txt', 'C:\Program Files\Folder2\file.txt', 'C:\Folder3\file.txt')

#region foreach statement
<# foreach (<iterator> in <collection>) {
	## Code goes here. <iterator> is available in here only
}
#>

foreach ($path in $paths) {
	$path
}

## Do something
foreach ($i in $paths) {
	Add-Content -Path $i -Value 'somevalue'
}

#region ForEach-Object cmdlet
$paths | ForEach-Object -Process {Add-Content -Path $_ -Value 'somevalue'}

<#
This:
$paths | foreach -Process {Add-Content -Path $_ -Value 'somevalue'}

..is not the same as this.
foreach ($i in $paths) {
	Add-Content -Path $i -Value 'somevalue'
}
#>

#region The foreach() Method
$paths.foreach({ Add-Content -Path $_ -Value 'somevalue' })
#endregion
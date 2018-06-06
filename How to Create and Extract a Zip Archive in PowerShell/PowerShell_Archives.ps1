#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep

#endregion
#region clean
Function Prompt(){}
$zip.Dispose()
Remove-Item $zipFile1Path -Confirm:$false
Remove-Item $zipFile2Path -Confirm:$false
If(Test-Path $extractPath){
    Get-ChildItem $extractPath | Remove-Item -Confirm:$false -Recurse
}
Clear-Host
#endregion

#region variables
$zipFile1Path = 'C:\Temp\zip1.zip'
$zipFile2Path = 'C:\Temp\zip2.zip'
$toZipDir = 'C:\Temp\Zip'
$toZipDir2 = 'C:\Temp\Zip2'
$extractPath = 'C:\Temp\Extract'
$file1 = 'C:\Temp\File1.txt'
$file2 = 'C:\Temp\File2.txt'
$file3 = 'C:\Temp\File3.txt'
#endregion

#region pre-5
#region prereqs
Add-Type -Assembly 'System.IO.Compression.FileSystem' #.NET 4.5
#endregion

#region create
[System.IO.Compression.ZipFile]::CreateFromDirectory($toZipDir, $zipFile1Path)
[IO.Compression.ZipFile]::OpenRead($zipFile1Path).Entries.Name

$zip = [System.IO.Compression.ZipFile]::Open($zipFile2Path, 'create') # update, read
$zip.Entries.Name

$zip.Dispose()
#endregion

#region update
$compressionLevel = [System.IO.Compression.CompressionLevel]::Fastest #Fastest, NoCompression, Optimal

$zip = [System.IO.Compression.ZipFile]::Open($zipFile2Path, 'update')
$zip.Entries.Name
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file1, (Split-Path $file1 -Leaf), $compressionLevel)
$zip.Entries.Name

$zip.Dispose()
#endregion

#region extract
$zip = [System.IO.Compression.ZipFile]::Open($zipFile2Path, 'read')
[System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $extractPath)
Get-ChildItem $extractPath

Get-ChildItem $extractPath | Remove-Item -Confirm:$false

[System.IO.Compression.ZipFileExtensions]::ExtractToFile($zip.Entries[0], "$extractPath\ExtractedFile1.txt", $true)
Get-ChildITem $extractPath
$zip.Entries | Where-Object Name -like *.txt | ForEach-Object{[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$extractPath\$($_.Name)", $true)}
Get-ChildITem $extractPath

$zip.Dispose()
#endregion
#endregion

#region between clean
$zip.Dispose()
Get-ChildItem $extractPath | Remove-Item -Confirm:$false
Remove-Item $zipFile1Path -Confirm:$false
Remove-Item $zipFile2Path -Confirm:$false
Clear-Host
#endregion

#region 5
#region create
Compress-Archive -Path $toZipDir -DestinationPath $zipFile1Path
[IO.Compression.ZipFile]::OpenRead($zipFile1Path).Entries.Name

Compress-Archive -Path $file1,$file2 -DestinationPath $zipFile2Path
[IO.Compression.ZipFile]::OpenRead($zipFile2Path).Entries.Name
#endregion

#region update
Compress-Archive -Path $toZipDir2 -DestinationPath $zipFile1Path -Update
[IO.Compression.ZipFile]::OpenRead($zipFile1Path).Entries.Name

Compress-Archive -Path $file3 -DestinationPath $zipFile2Path -Update
[IO.Compression.ZipFile]::OpenRead($zipFile2Path).Entries.Name
#endregion

#region extract
Expand-Archive -Path $zipFile1Path -DestinationPath $extractPath
Get-ChildItem $extractPath -Recurse

Get-ChildItem $extractPath | Remove-Item -Confirm:$false -Recurse

Expand-Archive -Path $zipFile2Path -DestinationPath $extractPath
Get-ChildItem $extractPath -Recurse
#endregion
#endregion
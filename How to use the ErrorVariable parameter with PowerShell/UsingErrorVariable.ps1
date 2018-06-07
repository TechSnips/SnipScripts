
#region Using ErrorVariable
Get-Childitem -Path c:\temp\readme.txt -ErrorVariable FileError
if ($FileError) {
    New-Item -Path c:\temp -Name readme.txt
}

$FileError.Count
$FileError
$FileError[0].Exception.GetType()

Get-ChildItem -Path c:\temp\help.doc -ErrorVariable +FileError
$FileError.Count
$FileError[-1].Exception

Get-Service TechSnips -ErrorAction Ignore -ErrorVariable ServiceError
$ServiceError.Count
#endregion
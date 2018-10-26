#region Finding files in AWS S3

$BucketName = 'snip-videos'

#region Get all files
Get-S3Object -BucketName $BucketName
#endregion

#region Get a single file
$Params = @{
    BucketName = $BucketName
    Key = 'how to assign specific services to users in office 365 using powershell/final.mp4'
}
Get-S3Object @Params
#endregion

#region Find by key prefix
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how to'
}
Get-S3Object @Params
#endregion

#region Limit file count
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how to'
    MaxKey = 15
}
Get-S3Object @Params | Format-Table Key
#endregion

#region Find by marker
$Params = @{
    BucketName = $BucketName
    Marker = 's'
}
Get-S3Object @Params | Format-Table Key
#endregion

#endregion

#region Downloading files in AWS

#region A single file
$Params = @{
    BucketName = $BucketName
    Key = 'how to assign specific services to users in office 365 using powershell/final.mp4'
    File = 'D:\TechSnips\tmp\final.mp4'
}
Read-S3Object @Params

Get-Item $Params.File
Remove-Item $Params.File -Confirm:$false
#endregion

#region Based on key prefix
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how'
    Folder = 'D:\TechSnips\tmp\'
}
Read-S3Object @Params

Get-ChildItem $Params.Folder

#region Needs to reference a folder
$Params.KeyPrefix = 'how to assign specific services to users in office 365 using powershell'
Get-S3Object -BucketName $BucketName -KeyPrefix $Params.KeyPrefix | Format-Table Key
Read-S3Object @Params

Get-ChildItem $Params.Folder
Get-ChildItem $Params.Folder | Remove-Item -Confirm:$false
#endregion
#endregion

#region A group of objects based on last modified date
$Params = @{
    BucketName = $BucketName  
    KeyPrefix = 'how to assign specific services to users in office 365 using powershell'
    ModifiedSinceDate = (Get-Date).AddDays(-1)
    Folder = 'D:\TechSnips\tmp'
}
Read-S3Object @Params

Get-ChildItem $Params.Folder

#region A folder with recently modified files
$Params.KeyPrefix = 'how to set up nic teaming in windows server 2019'
Read-S3Object @Params

Get-S3Object -BucketName $BucketName -KeyPrefix $Params.KeyPrefix

Get-ChildItem $Params.Folder
Get-ChildItem $Params.Folder | Remove-Item -Confirm:$false
#endregion
#endregion

#endregion
#region
#Upload 5 files to our bucket
$results = Get-ChildItem E:\Ipswitch -Recurse -Include "*.txt" 
foreach ($path in $results) {
	Write-Host $path
	$filename = [System.IO.Path]::GetFileName($path)
    $props1 = @{
    'BucketName' = 'snipbucket'
    'Region'     = 'eu-west-1'
    'AccessKey'  = ''
    'SecretKey'  = ''
    'File'       = $path
    'Key'        = $filename}
	Write-S3Object @props1}
#endregion

#region
.\s3.ps1 -bucket snipbucket -region eu-west-1 -Access  `
 -secret  

 ii awss3.html
#endregion  
<#
    #How to Monitor an Amazon S3 Bucket for New Files with PowerShell

    Prerequisites:
    AWS Account
    Access Keys
    Powershell Module: AWSPowershell

    SNIPS
    INSTALLING A MODULE FROM THE POWERSHELL GALLERY
#>

#region
# We need to create a user in IAM (Identity Access Management), so that we 
# can programmatically access the S3 bucket.
# https://console.aws.amazon.com/iam/
#endregion

#region
param 
( 
    [string]$bucket, 
    [string]$region,
    [string]$Access,
    [string]$secret
)

$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
#endregion

#region
$props2 = @{
    'BucketName' = $bucket
    'Region'     = $region
    'AccessKey'  = $access
    'SecretKey'  = $secret}
$OlderThan = 5
$files = Get-S3Object @props2
$newfiles = @()
$oldfiles = @()

Foreach ($file in $files){
    if($file.LastModified -gt (Get-Date).AddMinutes(-$OlderThan))
    {
        $newfiles += $file
    }
     Else
    {
        $oldfiles += $file
    }
}
#endregion

#region
$frag1 = $oldfiles | select BucketName,Key,LastModified,Size | ConvertTo-Html -fragment -PreContent `
 "<H2>Existing Files in S3 Bucket $($bucket) </H2> $(Get-date)" | Out-String
     
$frag2 = $newfiles | select BucketName,Key,LastModified,Size | ConvertTo-Html -fragment -PreContent `
 "<H2>Files Added to the S3 Bucket $($bucket) In Last 5 minutes</H2> $(Get-date)" | Out-String
  
ConvertTo-HTML -head $header -PostContent $frag1,$frag2 -PreContent "<h1>S3 Bucket Monitor</h1>" `
 | out-file E:\techsnip\awss3.html
 #endregion
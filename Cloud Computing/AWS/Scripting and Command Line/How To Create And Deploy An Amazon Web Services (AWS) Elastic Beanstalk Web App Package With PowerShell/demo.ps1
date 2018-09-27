#requires -Module AWSPowerShell

<#
We're going to follow a five-step process to deploy a package to a new EB application.

- creating the application
- creating the environment
- uploading the package to make it available to the application
- create a new version of the application
- deploy the new version to the environment

#>

#region Walk through all of the steps to create an app and deploy a package

$ebApp = New-EBApplication -ApplicationName 'TechSnips'

## Find available solution stack details. We're using solution stack over template because it has a default configuration already

(Get-EBAvailableSolutionStackList).SolutionStackDetails

## Create a new environment
$parameters = @{
      ApplicationName = 'TechSnips'
      EnvironmentName = 'Testing'
      SolutionStackName = '64bit Windows Server Core 2012 R2 running IIS 8.5'
      Tier_Type = 'Standard'
      Tier_Name = 'WebServer'
}
New-EBEnvironment @parameters

## Create a folder of files and compress into a ZIP file
Get-ChildItem -Path 'C:\MyPackageFolder'
Compress-Archive -Path 'C:\MyPackageFolder\*' -DestinationPath 'C:\package.zip' -Update

## Create an S3 bucket if one doesn't already exist
New-S3Bucket -BucketName 'techsnipsapp'

## Upload the package to S3
Write-S3Object -BucketName 'techsnipsapp' -File 'C:\package.zip'

## Create the new app version using a unique number
$verLabel = [System.DateTime]::Now.Ticks.ToString()
$newVerParams = @{
      ApplicationName       = 'TechSnips'
      VersionLabel          = $verLabel
      SourceBundle_S3Bucket = 'techsnipsapp'
      SourceBundle_S3Key    = 'package.zip'
}
New-EBApplicationVersion @newVerParams

## Deploy the new version to the environment
Update-EBEnvironment -ApplicationName 'TechSnips' -EnvironmentName 'Testing' -VersionLabel $verLabel -Force

## Check to ensure the health is Green again once the deployment finishes
Get-EBEnvironment -ApplicationName 'TechSnips' -EnvironmentName 'Testing'

#endregion

## Review the New-AwsElasticBeanstalk.ps1 script

## Dot source the function
. .\New-AwsBeanstalkApp.ps1

## Call the function creating an app called MyAWSapp
$parameters = @{
	ApplicationName = 'MyNewApp'
	Description = 'This is my new app'
	EnvironmentType = '64bit Windows Server Core 2016 v1.2.0 running IIS 10.0'
	CreateEnvironmentName = 'TestEnv'
	DeployToEnvironmentName = 'TestEnv'
	PackageFolderPath = 'C:\MyPackageFolder'
	S3BucketName = 'techsnipsapp'
    Verbose = $true
}
New-AWSBeanstalkApp @parameters
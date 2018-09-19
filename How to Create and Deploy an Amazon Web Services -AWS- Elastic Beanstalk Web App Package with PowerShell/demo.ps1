## Review the New-AwsElasticBeanstalk.ps1 script

## Dot source the function
. .\New-AwsBeanstalkApp.ps1

## Call the function creating an app called MyAWSapp
$parameters = @{
  ApplicationName MyAWSApp -Description 'My app' -EnvironmentName 'Development','Stage','Production' -EnvironmentType '64bit Windows Server Core 2016 v1.2.0 running IIS 10.0'
}
New-AwsBeanstalkApp 

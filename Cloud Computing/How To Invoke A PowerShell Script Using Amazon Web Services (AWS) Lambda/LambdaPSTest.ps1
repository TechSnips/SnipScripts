# Required Modules
Install-Module AWSPowerShell -Scope CurrentUser
Install-Module AWSLambdaPSCore -Scope CurrentUser

# Import AWS Modules For Demo
Import-Module AWSPowerShell -Force
Import-Module AWSLambdaPSCore -Force

#region Keys
$accessKey = ''
$secretKey = ''
#endregion

# Initialize default credential profile
Initialize-AWSDefaultConfiguration -AccessKey $accessKey -SecretKey $secretKey -Region us-east-1

# Get current list of Lambda functions
Get-LMFunctionList

# Get the list of available PowerShell Lambda templates
Get-AWSPowerShellLambdaTemplate

# Create a starter based on the Basic template
New-AWSPowerShellLambda -ScriptName PSTest -Template Basic

# Publish the new PowerShell based Lambda function
$publishPSLambdaParams = @{
    Name = 'PSTest'
    ScriptPath = '.\PSTest\PSTest.ps1'
    Region = 'us-east-1'
    IAMRoleArn = 'lambda_basic_execution'
}
Publish-AWSPowerShellLambda @publishPSLambdaParams

# Get list of Lambda functions including the one we just created
Get-LMFunctionList

# Invoke the new PowerShell function
$results = Invoke-LMFunction -FunctionName PSTest -InvocationType Event
$results | Select-Object -Property *

# Get the log events from the invoked function
Get-CWLLogGroup
$logs = Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/PSTest
$logs.Events


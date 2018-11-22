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
Initialize-AWSDefaultConfiguration -AccessKey $accessKey -SecretKey $secretKey

# Get the list of available PowerShell Lambda templates
Get-AWSPowerShellLambdaTemplate

# Create a starter based on the Basic template
New-AWSPowerShellLambda -ScriptName InputTest -Template Basic

code .\InputTest\InputTest.ps1

# Publish the new PowerShell based Lambda function
$publishPSLambdaParams = @{
    Name = 'InputTest'                            # Name of the Lambda function
    ScriptPath = '.\InputTest\InputTest.ps1'      # Path to the PowerShell script file
    Region = 'us-east-1'                          # Local Region. Use Get-AWSRegion to find yours
    IAMRoleArn = 'lambda_basic_execution'         # IAM role used that this function will run as
}
Publish-AWSPowerShellLambda @publishPSLambdaParams

# Get list of Lambda functions
Get-LMFunctionList

$payLoad = @{
    FirstName = 'Matt'
    LastName = 'McElreath'
    Department = 'Accounting'
} | ConvertTo-Json

Invoke-LMFunction -FunctionName InputTest -Payload $payLoad

# Get the log events from the invoked function
$logs = Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/InputTest
$logs.Events

code .\InputTest\InputTest.ps1

Publish-AWSPowerShellLambda @publishPSLambdaParams

Invoke-LMFunction -FunctionName InputTest -Payload $payLoad

# Get the log events from the invoked function
$logs = Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/InputTest
$logs.Events

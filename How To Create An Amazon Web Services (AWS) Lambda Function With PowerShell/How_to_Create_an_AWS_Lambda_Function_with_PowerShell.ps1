#region Install_AWS_Module

# Install the AWS Module - PowerShell Core.
Install-Module -Name AWSPowerShell.NetCore -Scope CurrentUser -Force
Import-Module -Name AWSPowerShell.NetCore
#Install-Module -Name AWSPowerShell -Scope CurrentUser -Force # Install the AWS Module - Windows PowerShell.

# AWS has it's own built in way to discover functions.  You could also always use Get-Command as well.
Get-AWSCmdletName -Service Lambda

# Create .aws directory if you haven't already - this is one of the default locations the AWS SDK will look for connections.
$credentialsFile = New-Item -Path $env:USERPROFILE\.aws -ItemType File -Name credentials -Force

# Add the contents to the credentials file.
$credentialsFileContents = @"
[default]
aws_access_key_id=PUTYOURIDHERE
aws_secret_access_key=PUTYOURKEYHERE
"@
Add-Content -Path $credentialsFile -Value $credentialsFileContents
Get-Content -Path $credentialsFile
Clear-Host

# Every AWS PowerShell command can take -Region and -ProfileName
# Set default region so you don't need to specify the region on every command.
Set-DefaultAWSRegion -Region us-east-2
# You can also optionally set the AWSCredential
Set-AWSCredential -ProfileName default

# You should be able to query Lambda Functions without an error.
Get-LMFunctionList
#endregion Install_AWS_Module

#region Lambda_Funtion_Creation

# No Lambda functions yet.
Get-LMFunctionList

# Create/Publish a new function
# Create Python 3.* Code for Lambda
$pythonCode = @"
def handler(event, context):
    message = 'Hello from AWS {} {}!'.format(event['first_name'], event['last_name'])
    print(message)
    return {
        'message' : message
    }
"@
Out-File -FilePath $env:USERPROFILE\helloworld.py -InputObject $pythonCode -Force

# Zip it up
Compress-Archive -Path $env:USERPROFILE\helloworld.py -DestinationPath $env:USERPROFILE\HelloLambda.zip -Force
$lambdaZip = Get-Item -Path $env:USERPROFILE\HelloLambda.zip

# We'll need to specify our IAM account for the Lambda function.
$awsLambdaRole = Get-IAMRole -RoleName role_lambda | Select-Object -ExpandProperty Arn

# Since there are a lot of parameters, for cleanliness we'll splat the params.
# Handler in this case is the name of the file 'helloworld' dot function name 'handler'
$publishLambdaFunctionParams = @{
    FunctionName = 'Python_HelloWorld'
    Runtime = 'python3.6'
    ZipFilename = $lambdaZip
    Handler = 'helloworld.handler'
    Role = $awsLambdaRole
}
Publish-LMFunction @publishLambdaFunctionParams

# See that the function is created.
Get-LMFunctionList

# Invoke the function
$payload = @{
    first_name = 'John'
    last_name = 'Smith'
} | ConvertTo-Json

# A 'RequestResponse' will return a 200
# A 'Event' will return a 202
# A 'DryRun' will return a 204
$results = Invoke-LMFunction -FunctionName Python_HelloWorld -InvocationType Event -Payload $payload
$results | Select-Object -Property *

# If we view the AWS CloudWatch logs, we can see our Lambda function worked and the output.
Get-CWLLogGroup
$events = Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/Python_HelloWorld
$events.Events
#endregion Lambda_Funtion_Creation

# Areas where AWS config info is stored
Get-AWSCredential -ListProfileDetail
Get-Content $env:USERPROFILE/.aws/config
Get-Content $env:USERPROFILE/.aws/credentials

# PowerShell way
$AccessKey = "AKIAISA5DL245XXXXXXX"
$SecretKey = "UqGzdUuS8WFJNvXPAokSKBYEFGyZILjRXXXXXXXX"
Set-AWSCredentials -AccessKey $AccessKey -SecretKey $SecretKey -StoreAs TechSnips

Get-AWSCredential -ListProfileDetail

# AWS CLI way
aws configure
aws configure --profile freetier

# Removing Profiles
Remove-AWSCredentialProfile -ProfileName TechSnips
Get-AWSCredential -ListProfileDetail
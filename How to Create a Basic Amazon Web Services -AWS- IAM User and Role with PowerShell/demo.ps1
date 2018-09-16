Set-AWSCredential -AccessKey 'XXXXXXXX' -SecretKey 'XXXXXXXXX'

New-IAMUser -UserName AutomateBoringStuff

$json = '{
>>     "Version": "2012-10-17",
>>     "Statement": [
>>         {
>>             "Effect": "Allow",
>>             "Principal" : { "AWS": "arn:aws:iam::013223035658:user/AutomateBoringStuff" },
>>             "Action": "sts:AssumeRole"
>>         }
>>     ]
>> }'

New-IAMRole -AssumeRolePolicyDocument $json -RoleName 'AllAccess'

$policyArn = (Get-IAMPolicies | where {$_.PolicyName -eq 'AdministratorAccess'}).Arn
PS> Register-IAMUserPolicy -PolicyArn $policyArn -UserName AutomateBoringStuff

$key = New-IAMAccessKey -UserName AutomateBoringStuff

Set-AWSCredential -AccessKey $key.AccessKeyId -SecretKey $key.SecretAccessKey -StoreAs 'Default'

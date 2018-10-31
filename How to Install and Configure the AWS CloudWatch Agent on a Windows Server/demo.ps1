<#
	
	Prerequisites:
		AWS Account
		A running EC2 instance
			- the AWS Systems Manager Agent (SSM Agent) 2.2.93.0 or later (comes installed by default)
	Snip suggestions:
		N/A
	Scenario:
		1. Create the IAM role.
		2. Attach IAM role to the instance.
		3. Download the CloudWatch agent on the EC2 instance.
		4. Create the CloudWatch agent configuration file.
		5. Start the CloudWatch agent.
		6. Verify the CloudWatch agent is sending information to CloudWatch.
#>

#region Create and attach the IAM role
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent.html
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/iam-roles-for-amazon-ec2.html#attach-iam-role
#endregion

#region Download and install the CloudWatch Agent on the EC2 instance
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-EC2-Instance.html
$parameters = @{
	Uri = 'https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip'
	OutFile = "$env:TEMP\AmazonCloudWatchAgent.zip"
}
Invoke-WebRequest @parameters

Expand-Archive -Path "$env:TEMP\AmazonCloudWatchAgent.zip" -DestinationPath "$env:TEMP\AmazonCloudWatchAgent"

Set-Location -Path "$env:TEMP\AmazonCloudWatchAgent"
.\install.ps1
#endregion

#region Create the CloudWatch agent configuration file
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file-wizard.html

Set-Location -Path 'C:\Program Files\Amazon\AmazonCloudWatchAgent\'
.\amazon-cloudwatch-agent-config-wizard.exe
#endregion

#region Start the CloudWatch agent
.\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c file:'C:\Program Files\Amazon\AmazonCloudWatchAgent\config.json' -s
#endregion

#region Ensure the CloudWatch agent is forwarding events
start 'https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logs:'
#endregion
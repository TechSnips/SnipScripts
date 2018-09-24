#region Starting an AWS instance

$instance = Get-EC2Instance -InstanceId 'i-0153178dca3da21aa'
$instance.Instances

$instanceId = $instance.Instances.InstanceId

Start-EC2Instance -InstanceId $instanceId

#endregion

#region Checking on status. 

## Nothing --what gives?
Get-EC2InstanceStatus -InstanceId $instanceId

## Wait for it......
Get-EC2InstanceStatus -InstanceId $instanceId

## Nothing useful
Get-EC2InstanceStatus -InstanceId $instanceId

## That's better. We can now see if it's running
(Get-EC2InstanceStatus -InstanceId $instanceId).InstanceState

#endregion

#region Stopping an EC2 instance

## Same process but we can use the pipeline to in either situation
$instance | Stop-EC2Instance

## Check the status to ensure it's stopped
Get-EC2InstanceStatus -InstanceId $instanceId

#endregion

#region Starting and stopping many instances at once

## Using the filter. This can match any number of instances

## https://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Instance.html

$instance = Get-EC2Instance -Filter @{'Name'='instance-id';'Value'='i-0153178dca3da21aa'}
$instance | Start-EC2Instance

Get-EC2Instance | Start-EC2Instance
Get-EC2Instance | Stop-EC2Instance

#endregion

#region Waiting for instances to change state

## We need to figure out how to determine the state first. We need some kind of up/down "flag"

## Dive in deeper and deeper and deeper
(Get-EC2InstanceStatus -InstanceId $instanceId).InstanceState

(Get-EC2InstanceStatus -InstanceId $instanceId).InstanceState.Name

(Get-EC2InstanceStatus -InstanceId $instanceId).InstanceState.Name.Value

## Ensure the instances are stopped
Get-EC2Instance | Stop-EC2Instance

## We need to fix that "issue" where Get-EC2InstanceStatus doesn't work for stopped instances
## This check needs to work for all states
Get-EC2InstanceStatus -IncludeAllInstance $true

## We have a way to accurately figure out if an instance is started or not now. Let's now check it continually until it's up/down

$desiredState = 'running'
$retryInterval = 5 ## seconds
while ((Get-EC2InstanceStatus -IncludeAllInstance $true -InstanceId $instanceId).InstanceState.Name.Value -ne $desiredState) {
	Write-Host "Waiting for our instance to reach the state of [$($desiredState)]..."
	Start-Sleep -Seconds $retryInterval
}

## Change the desired state and try it again
$desiredState = 'stopped'

## Let's now stop this instance in the management console
## https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=instanceId

#endregion

#region Creating a simple wait function

function Wait-EC2InstanceState {
	[OutputType('void')]
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[Amazon.EC2.Model.Reservation]$Instance,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('running','stopped')]
		[string]$DesiredState,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$RetryInterval = 5
	)

	$instanceId = $Instance.Instances.InstanceId
	while ((Get-EC2InstanceStatus -IncludeAllInstance $true -InstanceId $instanceId).InstanceState.Name.Value -ne $DesiredState) {
		Write-Verbose "Waiting for our instance to reach the state of [$($DesiredState)]..."
		Start-Sleep -Seconds $RetryInterval
	}
}


Get-EC2Instance | Wait-EC2InstanceState -DesiredState running -Verbose

#endregion

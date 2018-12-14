<#
	Prerequisites:
		- An AWS account
		- An EC2 instance with an attached volume
		- Authenticated with an IAM user with the CreateSnapshot permission (arn:aws:ec2:region::snapshot/*)
#>

#region Check current snapshots

Get-EC2Snapshot
Get-EC2Snapshot -OwnerId self

## View snapshots in EC2 console
https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Snapshots:sort=snapshotId

#endregion

#region Create the EBS snapshot

## Find the EC2 instance ID
(Get-EC2Instance).instances
$instanceId = (Get-EC2Instance).instances.InstanceId

## Find the volume ID attached to the instance

$volumes = Get-EC2Volume | Where-Object { $_.attachments.InstanceId -eq $instanceId }

## Create the snapshots
foreach ($volume in $volumes) {
	New-EC2Snapshot -VolumeId $volume.VolumeId
}
#endregion

#region Verify snapshot exists
Get-EC2Snapshot -OwnerId self

## Create a little wait code

while ((Get-EC2Snapshot -OwnerId self).where({ $_.State -eq 'Pending'})) {
	Write-Host 'Still waiting for the snapshots to complete...'
}

## Verify again
Get-EC2Snapshot -OwnerId self

#endregion


#region Create the VPC

$network = '10.0.0.0/16'
$vpc = New-EC2Vpc -CidrBlock $network
$vpc

Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsSupport $true
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostnames $true

#endregion

#region Create and attach the Internet gateway to the VPC

$gw = New-EC2InternetGateway
$gw

Add-EC2InternetGateway -InternetGatewayId $gw.InternetGatewayId -VpcId $vpc.VpcId

#endregion

#region Create the routing table and default route

$rt = New-EC2RouteTable -VpcId $vpc.VpcId

New-EC2Route -RouteTableId $rt.RouteTableId -GatewayId $gw.InternetGatewayId -DestinationCidrBlock '0.0.0.0/0'

#endregion

#region Create the subnet and register it with the route table

Get-EC2AvailabilityZone

$sn = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24' -AvailabilityZone 'us-east-1d'
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $sn.SubnetId

#endregion

#region Find the AMI to use

## Check out our options
Get-EC2ImageByName

## Grab the one we need
$ami = Get-EC2ImageByName -Name 'WINDOWS_2016_BASE'

#endregion

#region Create the instance and wait for it

$params = @{
	ImageId = $ami.ImageId
	AssociatePublicIp = $false
	InstanceType = 't2.micro'
	SubnetId = $sn.SubnetId
}
$instance = New-EC2Instance @params

## Monitor the status until it comes up

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

Get-EC2Instance -InstanceId $instance.Instances.InstantId | Wait-EC2InstanceState -DesiredState running -Verbose

#endregion

#region Function to bring it all together

.\New-CustomEC2Instance.ps1

$parameters = @{
	VpcCidrBlock = '10.0.0.0/16'
	EnableDnsSupport = $true
	SubnetCidrBlock = '10.0.1.0/24'
	OperatingSystem = 'Windows Server 2016'
	SubnetAvailabilityZone = 'us-east-1d'
	InstanceType = 't2.micro'
	Wait = $true
	Verbose = $true
}
New-CustomEC2Instance @parameters

#endregion
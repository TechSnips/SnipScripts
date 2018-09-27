#region Authenticate

Set-AwsCredential -AccessKey <access key here> -SecretKey <secret key here>

#endregion

#region Creating the network stack

#region Creating the Virtual Private Cloud (VPC)

#region Create the VPC using a user-defined CIDR block (network)

$network = '10.0.0.0/16'
$vpc = New-EC2Vpc -CidrBlock $network
$vpc

#endregion

#region Add DNS support to the VPC

## Ensure all EC2 instances added to this VPC are able to resolve DNS names
## This ensure all EC2 instances will point to Amazon DNS servers when created
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsSupport $true
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostnames $true

#endregion

#region Create the internet gateway that will act as a router for Internet traffic for our VPC

$gw = New-EC2InternetGateway
$gw

#endregion

#region Associate the internet gateway to our VPC so that EC2 instances on this VPC will be able to route to the Internet

Add-EC2InternetGateway -InternetGatewayId $gw.InternetGatewayId -VpcId $vpc.VpcId

#endregion

#region Create a new route table on our VPC so we can add a default route to it

$rt = New-EC2RouteTable -VpcId $vpc.VpcId

#endregion

#region Create a default route

## Create a default route (default gateway) to the route table pointing to the internet gateway to complete
## the configuration to enable EC2 instances attached to this VPC to get to the Internet
New-EC2Route -RouteTableId $rt.RouteTableId -GatewayId $gw.InternetGatewayId -DestinationCidrBlock '0.0.0.0/0'

#endregion

#region Create the subnet and add it to the route table

## Find the name of any available availability zone
Get-EC2AvailabilityZone

## Create the subnet with a CIDR block inside of the VPC's network
$sn = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24' -AvailabilityZone 'us-east-1d'

## Associate the subnet with the route table
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $sn.SubnetId

#endregion

#endregion

#region Find the AMI and create the EC2 instance

## Find the AMI name you need
Get-EC2ImageByName

## Specify the name to get the image object
$ami = Get-EC2ImageByName -Name 'WINDOWS_2016_BASE'

## Find the instance type you'd like to create -- https://aws.amazon.com/ec2/instance-types/

## Specify the AMI image the instance will use, ensure the instance has a public IP addres, specify the instance type
## and attach the created subnet so that instance's network adapter will use it.
$params = @{
	ImageId = $ami.ImageId
	AssociatePublicIp = $true
	InstanceType = 't2.micro'
	SubnetId = $sn.SubnetId
}
New-EC2Instance @params

#endregion

#region Custom function to wrap all of this up

## All code we've been doing has been packed up into a neat function called New-CustomEC2Instance
## Open the script

#endregion

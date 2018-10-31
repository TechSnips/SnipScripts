function New-CustomEC2Instance {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$VpcCidrBlock,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$EnableDnsSupport,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SubnetCidrBlock,

		[Parameter(Mandatory)]
		[ValidateSet('Windows Server 2016')]
		[ValidateNotNullOrEmpty()]
		[string]$OperatingSystem,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$SubnetAvailabilityZone,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$InstanceType,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Wait
	)

	begin {
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
	}

	process {
		## Create the VPC using a user-defined CIDR block (network) only if it doesn't already exist
		if (-not ($vpc = Get-EC2Vpc | where CidrBlock -eq $VpcCidrBlock)) {
			Write-Verbose -Message "Creating new VPC with CIDR block of [$($VpcCidrBlock)]..."
			$vpc = New-EC2Vpc -CidrBlock $VpcCidrBlock
		} else {
			Write-Verbose -Message "A VPC with the CIDR block [$($VpcCidrBlock)] has already been created."
		}
		
		## Enable DNS support on the VPC only if we've chosen to do so
		if ($EnableDnsSupport.IsPresent) {
			Write-Verbose -Message "Enabling DNS support on VPC ID [$($vpc.VpcId)]..."
			## Add DNS support to the VPC

			## Ensure all EC2 instances added to this VPC are able to resolve DNS names
			## This ensure all EC2 instances will point to Amazon DNS servers when created
			Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsSupport $true
			Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostnames $true
		}

		## Create the internet gateway that will act as a router for Internet traffic for our VPC only if one isn't already
		## attached to the VPC.
		if (-not ($gw = Get-EC2InternetGateway | where { $_.Attachments.VpcId -eq $vpc.VpcId })) {
			Write-Verbose -Message 'Creating new internet gateway...'
			$gw = New-EC2InternetGateway

			## Associate the internet gateway to our VPC so that EC2 instances on this VPC will be able to route to the Internet
			Write-Verbose -Message "Associating internet gateway ID [$($gw.InternetGatewayID)] with VPC ID [$($vpc.VpcId)]..."
			Add-EC2InternetGateway -InternetGatewayId $gw.InternetGatewayId -VpcId $vpc.VpcId
		} else {
			Write-Verbose -Message "An internet gateway is already attached to VPC ID [$($vpc.VpcId)]."
		}

		## Create a new route table on our VPC so we can add a default route to it only if it doeesn't already exist
		if (-not ($rt = Get-EC2RouteTable -Filter @{ Name='vpc-id'; Value=$vpc.VpcId })) {
			Write-Verbose -Message "Creating route table for VPC ID [$($vpc.VpcId)]..."
			$rt = New-EC2RouteTable -VpcId $vpc.VpcId
		} else {
			Write-Verbose -Message "Route table already exists for VPC ID [$($vpc.VpcId)]."
		}
		
		## Create a default route only if one doesn't already exist
		if (-not ($rt.Routes | where {$_.DestinationCidrBlock -eq '0.0.0.0/0'})) {
			## Create a default route (default gateway) to the route table pointing to the internet gateway to complete
			## the configuration to enable EC2 instances attached to this VPC to get to the Internet
			Write-Verbose -Message "Creating default route for route table ID [$($rt.RouteTableId)]..."
			New-EC2Route -RouteTableId $rt.RouteTableId -GatewayId $gw.InternetGatewayId -DestinationCidrBlock '0.0.0.0/0'
		} else {
			Write-Verbose -Message "A default route has already been created for route table ID [$($rt.RouteTableId)]."
		}

		## Create the subnet and add it to the route table only if there's not a subnet created already
		if (-not ($sn = Get-EC2Subnet -Filter @{ Name='vpc-id'; Value=$vpc.VpcId })) {
			Write-Verbose -Message "Creating and registering a subnet with CIDR block [$($SubnetCidrBlock)] with VPC ID [$($vpc.VpcId)]..."
			$sn = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock $SubnetCidrBlock -AvailabilityZone $SubnetAvailabilityZone
			Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $sn.SubnetId
		} else {
			Write-Verbose -Message "A subnet has already been created and registered with VPC ID [$($vpc.VpcId)]."
		}

		## Find the AMI
		switch ($OperatingSystem) {
			'Windows Server 2016' {
				$imageName = 'WINDOWS_2016_BASE'
			}
			default {
				throw "Unrecognized operating system: [$_]"
			}
		}
		
		## Ensure an AMI is found. Otherwise, return an error
		if (-not ($ami = Get-EC2ImageByName -Name $imageName)) {
			Write-Error -Message "No AMI found with the image name of [$($imageName)]."
		} else {
			Write-Verbose -Message 'Creating EC2 instance...'
			## Specify the AMI image the instance will use, ensure the instance has a public IP addres, specify the instance type
			## and attach the created subnet so that instance's network adapter will use it.
			$params = @{
				ImageId = $ami.ImageId
				AssociatePublicIp = $true
				InstanceType = $InstanceType
				SubnetId = $sn.SubnetId
			}
			$instance = New-EC2Instance @params

			if ($Wait.IsPresent) {
				$instance | Wait-EC2InstanceState -DesiredState 'running'
			}
		}
	}
}

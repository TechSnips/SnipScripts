# EC2 Instance Metadata
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html

$Url = 'http://169.254.169.254/latest/meta-data/public-hostname'

Invoke-RestMethod -Uri $Url -UseBasicParsing

$env:COMPUTERNAME

((Invoke-WebRequest -Uri $Url -UseBasicParsing).RawContent -split "`n")[-1]
<# 

To create a basic RDS intance in AWS requires knowing a few basic attributes:

- the name of the instance
- the engine (SQL Server, MariaDb, MySql and so on)
- the instance class which assigns what kind of resources the SQL Server this database will be ran on
- the maser username and password
- how big the database should be in gigabytes

#>

#region Find all of potential engine versions to use

## Inspect all possible engine versions
Get-RDSDBEngineVersion | Group-Object -Property Engine

## Inspect all of the available versions of the SQL Server Express engine. By default, the New-RDSDBInstance command
## we'll be using will use the latest version

Get-RDSDBEngineVersion -Engine 'sqlserver-ex' | Format-Table -Property EngineVersion

#endregion

#region Create the RDS database

## Find all available DB instances here --> https://aws.amazon.com/rds/instance-types/

## Ensure the configuration is allowed --> https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
$parameters = @{
    DBInstanceIdentifier = 'TechSnips2'
    Engine = 'sqlserver-ex'
    DBInstanceClass = 'db.t2.micro'
	MasterUsername = 'sa'
    MasterUserPassword = 'password' ## Do not to include a forward slash, @ symbol, double quotes or spaces
	AllocatedStorage = 20 ## Gigabytes
	PubliclyAccessible = $true ## to connect over the Internet
}
$instance = New-RDSDBInstance @parameters
$instance

## Wait until the instance has been created

(Get-RDSDBInstance -DBInstanceIdentifier $instance.DBInstanceIdentifier).DBInstanceStatus

while ((Get-RDSDBInstance -DBInstanceIdentifier $instance.DBInstanceIdentifier).DBInstanceStatus -ne 'available') {
	Write-Host 'Waiting for instance to be created...'
	Start-Sleep -Seconds 30
}

## Check out the created instances in the management console

Invoke-Item 'https://console.aws.amazon.com/rds/home?region=us-east-1#dbinstances:'

#endregion
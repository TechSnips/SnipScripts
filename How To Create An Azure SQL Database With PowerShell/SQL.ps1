<#
    Prerequisites:
    Azure Resource Manager (ARM) PowerShell module
    Azure Subscription
    Pricing And Overview - https://azure.microsoft.com/en-us/pricing/details/sql-database/single/
#>

#region
New-AzureRmResourceGroup -Name SNIPGRP -Location 'NorthEurope'
#EndRegion

#region
# Create the SQL Server
$cred = $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'sqladmin', $(ConvertTo-SecureString -String 'p@$$w0rd' -AsPlainText -Force))
$parameters = @{
    ResourceGroupName           = 'SNIPGRP'
    ServerName                  = 'snipsql'
    Location                    = 'northeurope'
    SqlAdministratorCredentials = $cred
    ServerVersion               = '12.0'
}
New-AzureRmSqlServer @parameters
#endRegion

#region
# Create the Database
$parameters = @{
    ResourceGroupName             = 'SNIPGRP'
    ServerName                    = 'snipsql'
    DatabaseName                  = 'demodb'
    RequestedServiceObjectiveName = 'S0'  # relates to pricing and performance tier
}
New-AzureRmSqlDatabase @parameters
#endregion

#region
# Create the firewall rule to allow inbound access
$parameters = @{
    ResourceGroupName = 'SNIPGRP'
    ServerName        = 'snipsql'
    FirewallRuleName  = 'AllowedIps'
    StartIpAddress    = 'xxx.xxx.xxx.xxx'
    EndIpAddress      = 'xxx.xxx.xxx.xxx'
}
New-AzureRmSqlServerFirewallRule @parameters
#endRegion

#region
# Access the database
# snipsql.database.windows.net
#endregion
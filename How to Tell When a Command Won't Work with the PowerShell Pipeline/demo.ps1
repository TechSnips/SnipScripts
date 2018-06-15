## Not Every Command Works with the Pipeline

## Check full help and look for the PARAMETERS section
Get-Help -Name Start-Service -Full

## Check out the DisplayName parameter. This does not accept pipeline input
(Get-Help -Name Start-Service -full).Parameters.parameter | where {$_.name -eq 'DisplayName'}

## Check out the InputObject parameter. This accepts pipeline input by value. Notice the ServiceController type
(Get-Help -Name Start-Service -full).Parameters.parameter | where {$_.name -eq 'InputObject'}

## Check out the Name parameter. This does not accept pipeline input
(Get-Help -Name Start-Service -full).Parameters.parameter | where {$_.name -eq 'Name'}

## Verify the input is of the right object type
Get-Service -Name wuauserv | Get-Member
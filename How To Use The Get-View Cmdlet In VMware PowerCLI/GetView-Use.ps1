#region Display environment
Clear-Host
Write-Output "PowerShell      : $($PSVersionTable.PSVersion)"
Write-Output "VMware PowerCLI : $((Get-Module -Name VMware.PowerCLI -ListAvailable).Version)"
Write-Output "vCenter         : $($global:DefaultVIServer.Name) $($global:DefaultVIServer.Version)"
#endregion

#region Why use Get-View?
Clear-Host
Get-Datastore -Name DS2 | Select-Object -Property *

# API Reference
# Download from https://code.vmware.com/apis/358/vsphere
#endregion

#region Syntax
Clear-Host
Get-Command -Name Get-View -Syntax
(Get-Command -Name Get-View).ParameterSets.Name
#endregion

#region GetViewByVIObject
Clear-Host
Get-Datastore -Name DS2 | Get-View
Get-Datastore -Name DS2 | Get-View | Select-Object -ExpandProperty Summary

Get-Datastore | Select-Object Name,
@{N = 'Shared'; E = {(Get-View -VIObject $_).Summary.MultipleHostAccess}}
#endregion

#region Get-View
Clear-Host

#region Basic
Get-View -ViewType Datastore |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#region  Limit what is returned
Get-View -ViewType Datastore -Property Summary.MultipleHostAccess |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#region Explicitly specify all that is required
Get-View -ViewType Datastore -Property Name, Summary.MultipleHostAccess |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#region Limit scope of search
$dc = Get-Datacenter -Name DC1
$sView = @{
  ViewType   = 'Datastore'
  Property   = 'Name', 'Summary.MultipleHostAccess'
  SearchRoot = Get-View -VIObject $dc | Select-Object -ExpandProperty MoRef
}
Get-View @sView |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#region Filtering on the server side - 1
$sView = @{
  ViewType   = 'Datastore'
  Property   = 'Name', 'Summary.MultipleHostAccess'
  SearchRoot = Get-View -VIObject $dc | Select-Object -ExpandProperty MoRef
  Filter     = @{
    'Name' = '^DS'
  }
}
Get-View @sView |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#region Filtering on the server side - 2
$sView = @{
  ViewType   = 'Datastore'
  Property   = 'Name', 'Summary.MultipleHostAccess'
  SearchRoot = Get-View -VIObject $dc | Select-Object -ExpandProperty MoRef
  Filter     = @{
    'Name'                       = '^DS'
    'Summary.MultipleHostAccess' = 'True'
  }
}
Get-View @sView |
  Select-Object Name, @{N = 'Shared'; E = {$_.Summary.MultipleHostAccess}}
#endregion

#endregion

#region Understanding $Error
$Error.GetType()
$Error.Count

Get-ChildItem -Path c:\temp\NotThere.log
Get-Service -Name TechSnips

$Error.Count
$Error.Clear()
$Error.Count

Get-Process -Name DoesNotExist
$Error[0]
Get-Alias -Name MarkTwain
$Error[0]
$Error[1]
$Error[0].GetType()
$Error[0] | Get-Member
$Error[0].CategoryInfo
$Error[0].InvocationInfo
$Error[0].Exception
$Error[0].Exception.GetType()


$ErrorRecord = $Error.Clone()
$ErrorRecord.Count
$ErrorRecord[0]
$ErrorRecord[0] | Get-Member
#endregion
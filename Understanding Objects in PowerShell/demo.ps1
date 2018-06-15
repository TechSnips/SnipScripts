<# We're going to be limited in this snip to two actions
    - Inspecting existing objects
    - Creating custom objects
#>

#region Inspecting Object Properties
$color = 'Red'
$color

## Only one property?
$color | Select-Object -Property *

## Dot notation
$color.Length

### Introducing the Get-Member cmdlet

Get-Member -InputObject $color
#endregion

#region Calling Methods
$color.Remove(1, 1)
#endregion

#region Types
'1' | Get-Member
1 | Get-Member
$true | Get-Member

$int = 1
$int.GetType().Name
#endregion

#region Creating Your Own Objects

$object = New-Object -TypeName PSObject
$object | Add-Member -MemberType NoteProperty -Name OSBuild -Value 'OSBuildffff'
$object | Add-Member -MemberType NoteProperty -Name OSVersion -Value 'Versionffffrf'

## type accelerator
$myFirstCustomObject = [pscustomobject]@{
	OSBuild   = 'OSBuild'
	OSVersion = 'Version'
}

$myFirstCustomObject | Get-Member

$myFirstCustomObject.OSBuild
$myFirstCustomObject.OSVersion
#endregion
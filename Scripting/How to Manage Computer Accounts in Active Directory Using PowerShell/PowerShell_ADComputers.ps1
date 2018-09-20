#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region New-ADComputer
#simplest
New-ADComputer 'Summit'

Get-ADComputer -Identity 'Summit'

#region Set more properties
$NewCompSplat01 = @{
    Name = 'Sunway TaihuLight'
    SamAccountName = 'Sunway.TaihuLight'
    Path = 'OU=Super Computers,OU=Machines,DC=techsnips,DC=local'
    Enabled = $true
}
New-ADComputer @NewCompSplat01

Get-ADComputer -Identity $NewCompSplat01.SamAccountName
#endregion

#region Copy from template computer
$GetCompSplat = @{
    Identity = 'Sunway.TaihuLight'
    Properties = 'Location','OperatingSystem','OperatingSystemHotfix','OperatingSystemServicePack','OperatingSystemVersion'
}
$templateComp = Get-ADComputer @GetCompSplat
New-ADComputer -Instance $templateComp -Name 'Sierra'

Get-ADcomputer -Identity 'Sierra'
#endregion
#endregion

#region Move

#Move computer
(Get-ADComputer -Identity 'Summit').DistinguishedName

$MoveCompSplat = @{
    Identity = (Get-ADComputer -Identity 'Summit').DistinguishedName
    TargetPath = 'OU=Super Computers,OU=Machines,DC=techsnips,DC=local'
}
Move-ADObject @MoveCompSplat

(Get-ADComputer -Identity 'Summit').DistinguishedName
#endregion

#region Get-ADComputer
#Filter for all computers
Get-ADComputer -Filter *

#region Filter for all Server 2016
Get-ADComputer -Filter {OperatingSystem -like '*2016*'}

Get-ADComputer -Filter {Enabled -eq $false}
#endregion

#region Get additional properties
Get-ADComputer -Identity 'Sierra' -Properties *

Get-ADComputer -Identity 'Sierra' -Properties IPv4Address
#endregion

#region Group memberships
Add-ADGroupMember -Identity 'IT' -Members (Get-ADComputer -Identity 'Sierra').SID

(Get-ADComputer -Identity 'Sierra' -Properties MemberOf).Memberof
#endregion

#region Get computers from a specific OU
Get-ADComputer -Filter * -SearchBase 'OU=Super Computers,OU=Machines,DC=techsnips,DC=local'
#endregion
#endregion

#region Set-ADComputer

#Certain properties
Set-ADComputer -Identity 'Summit' -Enabled $False

Get-ADComputer -Identity 'Summit'

#region Multiple properties
$SetCompSplat = @{
    Identity = 'Summit'
    Description = "DoE's finest."
    Location = 'Oak Ridge National Laboratory'
}
Set-ADComputer @SetCompSplat

Get-ADComputer -Identity 'Summit' -Properties Description,Location
#endregion

#region Properties without explicit parameter
$Comp = Get-ADComputer -Identity 'Summit' -Properties ProtectedFromAccidentalDeletion
$Comp.ProtectedFromAccidentalDeletion = $false
Set-ADComputer -Instance $Comp

Get-ADComputer $Comp -Properties ProtectedFromAccidentalDeletion
#endregion
#endregion

#region Remove-ADComputer

#One computer
Remove-ADComputer -Identity 'Sierra'

#region Filtered computers
$20mAgo = (Get-Date).AddMinutes(-20)
Get-ADComputer -Filter {Created -gt $20mAgo}
Get-ADComputer -Filter {Created -gt $20mAgo} | Remove-ADComputer -Confirm:$false
#endregion
#endregion
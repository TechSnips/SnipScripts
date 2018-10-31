#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region notes
#create
'Rampart','Dungeon','Castle' | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}
'Enroth','Nighon','Erathia' | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}
'Rangers','Warren' | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}
'Heroes','Creatures','Towns' | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}
New-ADGroup 'Infernal Troglodytes' -GroupScope Universal -GroupCategory Security
New-ADUser 'Gelu'
New-ADComputer 'Alexandretta'

#organize
'Rampart','Dungeon','Castle' | %{Add-ADGroupMember 'Towns' -Members $_}
Add-ADGroupMember 'Enroth' -Members 'Rampart'
Add-ADGroupMember 'Nighon' -Members 'Dungeon'
Add-ADGroupMember 'Erathia' -Members 'Castle'
Add-ADGroupMember 'Towns' -Members (Get-ADComputer 'Alexandretta').SID
Add-ADGroupMember 'Castle' -Members (Get-ADComputer 'Alexandretta').SID
Add-ADGroupMember 'Creatures' -Members 'Infernal Troglodytes'
Add-ADGroupMember 'Dungeon' -Members 'Warren'
Add-ADGroupMember 'Warren' -Members 'Infernal Troglodytes'
Add-ADGroupMember 'Rangers' -Members 'Gelu'
Add-ADGroupMember 'Heroes' -Members 'Rangers'
Add-ADGroupMember 'Rampart' -Members 'Rangers'

# clean

'Rampart','Dungeon','Castle','Enroth','Nighon','Erathia','Rangers','Warren','Heroes','Creatures','Towns','Infernal Troglodytes' | %{Remove-ADGroup $_ -Confirm:$false}
Remove-ADUser 'Gelu' -Confirm:$false
Remove-ADComputer 'Alexandretta' -Confirm:$false

#endregion

#region Types of objects
(Get-ADGroup -Identity 'Infernal Troglodytes' -Properties MemberOf).MemberOf

(Get-ADUser -Identity 'Gelu' -Properties MemberOf).MemberOf

(Get-ADComputer -Identity 'Alexandretta' -Properties MemberOf).MemberOf

#endregion

#region Finding an object's memberships' memberships
#One Level
ForEach($group in (Get-ADUser -Identity 'Gelu' -Properties MemberOf).MemberOf){
    (Get-ADGroup -Identity $group -Properties MemberOf).MemberOf
}

#endregion

#region Solving our problem with recursion
Function Get-ADRecursiveGroupMemberships{
    Param(
        [Microsoft.ActiveDirectory.Management.ADGroup]$group,
        [switch]$PassThru
    )
    $group = Get-ADGroup -Identity $group -Properties MemberOf
    If($PassThru){
        $group.DistinguishedName
    }
    If($group.memberof){
        ForEach($newGroup in $group.memberof){
            $newGroup
            Get-ADRecursiveGroupMemberships $newGroup
        }
    }
}

(Get-ADUser -Identity 'Gelu' -Properties MemberOf).MemberOf | ForEach-Object{Get-ADRecursiveGroupMemberships $_ -PassThru}
#endregion

#region Solving our problem with one function to rule them all

Function Get-ADObjectGroupMemberships{
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$DistinguishedName
    )
    Begin{
        Function Get-ADRecursiveGroupMemberships{
            Param(
                [Microsoft.ActiveDirectory.Management.ADGroup]$group,
                [switch]$PassThru
            )
            $group = Get-ADGroup -Identity $group -Properties memberof
            If($PassThru){
                $group.DistinguishedName
            }
            If($group.memberof){
                ForEach($newGroup in $group.memberof){
                    $newGroup
                    Get-ADRecursiveGroupMemberships $newGroup
                }
            }
        }
    }
    Process{
        (Get-ADObject -Identity $DistinguishedName -Properties MemberOf).MemberOf | `
        ForEach-Object {Get-ADRecursiveGroupMemberships $_ -PassThru} | Select-Object -Unique
    }
    End{}
}

Get-ADGroup -Identity 'Infernal Troglodytes' | Get-ADObjectGroupMemberships

Get-ADUser -Identity 'Gelu' | Get-ADObjectGroupMemberships

Get-ADComputer -Identity 'Alexandretta' | Get-ADObjectGroupMemberships

#endregion
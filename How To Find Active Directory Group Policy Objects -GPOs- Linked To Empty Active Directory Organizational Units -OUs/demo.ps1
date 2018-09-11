#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Sort OUs with GPO links by whether or not they have non-OU children

#Get all OUs with GPO links:
Get-ADOrganizationalUnit -Filter {LinkedGroupPolicyObjects -like "*"} | Format-Table Name

#Get all non-OU objects in each OU
Get-ADObject -Filter {ObjectClass -ne 'OrganizationalUnit'} <#-SearchBase $OU#> | Format-Table Name,ObjectClass

$emptyOUs = $nonEmptyOUs = @()
ForEach($OU in Get-ADOrganizationalUnit -Filter {LinkedGroupPolicyObjects -like "*"}){
    $objects = $null
    $objects = Get-ADObject -Filter {ObjectClass -ne 'OrganizationalUnit'} -SearchBase $OU
    If($objects){
        Write-Host "OU: '$($OU.Name)' is not empty"
        $nonEmptyOUs += $OU
    }Else{
        Write-Host "OU: '$($OU.Name)' is empty"
        $emptyOUS += $OU
    }
}

#result
$emptyOUs
$nonEmptyOUs

#endregion

#region Find GPOs linked to those empty OUs

#Linked GPO Guids
$emptyOUs[0].LinkedGroupPolicyObjects

#GPO from Guid
$emptyOUs[0].LinkedGroupPolicyObjects.Substring(4,36)
Get-GPO -Guid $emptyOUs[0].LinkedGroupPolicyObjects.Substring(4,36)

#Object to build output
$GPOsLinkedToEmptyOUs = @()

ForEach($OU in $emptyOUs){
    ForEach($GPOGuid in $OU.LinkedGroupPolicyObjects){
        $GPO = Get-GPO -Guid $GPOGuid.Substring(4,36)
        Write-Host "GPO: '$($GPO.DisplayName)' is linked to empty OU: $($OU.Name)"
        If($GPOsLinkedToEmptyOUs.GPOId -contains $GPO.Id){
            ForEach($LinkedGPO in ($GPOsLinkedToEmptyOUs | Where-Object {$_.GPOId -eq $GPO.Id})){
                $LinkedGPO.EmptyOU = [string[]]$LinkedGPO.EmptyOU + "$($OU.DistinguishedName)"
            }
        }Else{
            $GPOsLinkedToEmptyOUs += [PSCustomObject]@{
                GPOName = $GPO.DisplayName
                GPOId = $GPO.Id
                EmptyOU = $OU.DistinguishedName
                NonEmptyOU = ''
            }
        }
    }
}

#result
$GPOsLinkedToEmptyOUs | Format-List

#endregion

#region Check if those GPOs are linked to any OUs with children

ForEach($OU in $nonEmptyOUs){
    ForEach($GPO in $GPOsLinkedToEmptyOUs){
        If($OU.LinkedGroupPolicyObjects.Substring(4,36) -contains $GPO.GPOId){
            Write-Host "GPO: '$($GPO.GPOName)' also linked to non-empty OU: $($OU.Name)"
            If($GPO.NonEmptyOU){
                $GPO.NonEmptyOU = [string[]]$GPO.NonEmptyOU + $OU.DistinguishedName
            }Else{
                $GPO.NonEmptyOU = $OU.DistinguishedName
            }
        }
    }
}

#Now
$GPOsLinkedToEmptyOUs | Format-List

#endregion

#region Bring it all together into a function with useful output

Function Get-GPOsLinkedToEmptyOUs{
    [cmdletbinding()]
    Param()
    $emptyOUs = $nonEmptyOUs = @()
    ForEach($OU in Get-ADOrganizationalUnit -Filter {LinkedGroupPolicyObjects -like "*"}){
        $objects = $null
        $objects = Get-ADObject -Filter {ObjectClass -ne 'OrganizationalUnit'} -SearchBase $OU
        If($objects){
            Write-Verbose "OU: '$($OU.Name)' is not empty"
            $nonEmptyOUs += $OU
        }Else{
            Write-Verbose "OU: '$($OU.Name)' is empty"
            $emptyOUS += $OU
        }
    }
    $GPOsLinkedToEmptyOUs = @()
    ForEach($OU in $emptyOUs){
        ForEach($GPOGuid in $OU.LinkedGroupPolicyObjects){
            $GPO = Get-GPO -Guid $GPOGuid.Substring(4,36)
            Write-Verbose "GPO: '$($GPO.DisplayName)' is linked to empty OU: $($OU.Name)"
            If($GPOsLinkedToEmptyOUs.GPOId -contains $GPO.Id){
                ForEach($LinkedGPO in ($GPOsLinkedToEmptyOUs | Where-Object {$_.GPOId -eq $GPO.Id})){
                    $LinkedGPO.EmptyOU = [string[]]$LinkedGPO.EmptyOU + "$($OU.DistinguishedName)"
                }
            }Else{
                $GPOsLinkedToEmptyOUs += [PSCustomObject]@{
                    GPOName = $GPO.DisplayName
                    GPOId = $GPO.Id
                    EmptyOU = $OU.DistinguishedName
                    NonEmptyOU = ''
                }
            }
        }
    }
    ForEach($OU in $nonEmptyOUs){
        ForEach($GPO in $GPOsLinkedToEmptyOUs){
            If($OU.LinkedGroupPolicyObjects.Substring(4,36) -contains $GPO.GPOId){
                Write-Verbose "GPO: '$($GPO.GPOName)' also linked to non-empty OU: $($OU.Name)"
                If($GPO.NonEmptyOU){
                    $GPO.NonEmptyOU = [string[]]$GPO.NonEmptyOU + $OU.DistinguishedName
                }Else{
                    $GPO.NonEmptyOU = $OU.DistinguishedName
                }
            }
        }
    }
    $GPOsLinkedToEmptyOUs
}

Get-GPOsLinkedToEmptyOUs

$GPOsLinkedToEmptyOUs = Get-GPOsLinkedToEmptyOUs

$GPOsLinkedToEmptyOUs | Format-List


#endregion

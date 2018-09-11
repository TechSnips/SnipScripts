#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Go over prerequisites
$Name = 'Policy of Power'

#Retrieve the GPO and properties
Get-GPO -Name $Name
$GPO = Get-GPO -Name $Name

#Retrieve the for the GPO
Get-GPPermission -All -Name $Name | Where-Object {$_.Permission -eq "GpoApply"}
$scope = Get-GPPermission -All -Name $Name | Where-Object {$_.Permission -eq "GpoApply"}

#Find all OUs that have the GPO linked
Get-ADOrganizationalUnit -Filter * -Properties gplink | Where-Object {$_.gplink -like "*$($gpo.id)*"}
$OUs = Get-ADOrganizationalUnit -Filter * -Properties gplink | Where-Object {$_.gplink -like "*$($gpo.id)*"}

#Find all objects in scope in each OU
If($scope.Trustee.Name -contains "Authenticated Users"){
    ForEach($ou in $ous){
        Get-ADObject -SearchBase $ou.distinguishedname -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Select Name,ObjectClass
    }
}Else{
    $scopedObjects = @()
    #Get group members within scope
    ForEach($Group in ($scope | Where-Object {@("Group","Alias") -contains $_.Trustee.SidType})){
        $scopedObjects += Get-ADGroupMember $group.Trustee.Name | ForEach-Object {Get-ADObject $_.DistinguishedName}
    }
    #Add in users and computers within scope
    ForEach($object in ($scope | Where-Object {@("user","computer") -contains $_.Trustee.SIDType})){
        $scopedObjects += Get-ADObject $object.Trustee.DSPath
    }
    $scopedObjects = $scopedObjects | Select-Object -Unique
    #Find objects the GPO applies to
    Foreach($OU in $OUs){
        Get-ADObject -SearchBase $ou.DistinguishedName -Filter * | `
        Where-Object {@("user","computer") -contains $_.objectclass} | `
        Where-Object {$scopedObjects.Name -contains $_.name} | Select-Object Name,ObjectClass
    }
}

#endregion

#region Final Script
Function Get-GPImpact
{
    [cmdletbinding(
        DefaultParameterSetName="Name"
    )]
    Param(
        [Parameter(
            ParameterSetName="Name",
            Mandatory="True",
            ValueFromPipeline="True",
            ValueFromPipelineByPropertyName="True"
        )]
        [Alias('Name')]
        [string]$DisplayName
        ,
        [Parameter(
            ParameterSetName="ID",
            Mandatory="True",
            ValueFromPipeline="True",
            ValueFromPipelineByPropertyName="True"
        )]
        [Alias('ID')]
        [string]$GUID
    )
    Begin{}
    Process{
        Switch ($psCmdlet.ParameterSetName){
            "Name" {
                Write-Verbose "using name"
                Try{
                    $gpo = Get-GPO -Name $DisplayName
                }Catch{
                    Write-Error $error[0]
                    Return
                }
                $scope = Get-GPPermission -All -Name $DisplayName | ?{$_.Permission -eq "GpoApply"}
                Write-Verbose "Scope: $($scope.trustee.name)"
            }
            "ID" {
                Write-Verbose "using id"
                Try{
                    $gpo = Get-GPO -Id $ID
                }Catch{
                    Write-Error $error[0]
                    Return
                }
                $scope = Get-GPPermission -All -Id $ID | ?{$_.Permission -eq "GpoApply"}
                Write-Verbose "Scope: $($scope.trustee.name)"
            }
        }
        $ous = Get-ADOrganizationalUnit -Filter * -Properties gplink | Where-Object {$_.gplink -like "*$($gpo.id)*"}
        If((Get-ADDomain).LinkedGroupPolicyObjects -like "*$($gpo.id)*"){
            $ous += (Get-ADDomain).DistinguishedName
        }
        If($ous){
            ForEach($OU in $OUs){
                Write-Verbose "OU: $($OU.Name)"
            }
            If($scope.Trustee){
                If($scope.Trustee.Name -contains "Authenticated Users"){
                    Write-Verbose "Authenticated Users"
                    ForEach($ou in $ous){
                        Write-Verbose $ou.distinguishedname
                        Get-ADObject -SearchBase $ou.distinguishedname -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Select Name,ObjectClass
                    }
                }Else{
                    Write-Verbose "Objects"
                    $scopedObjects = @()
                    #Get group members within scope
                    ForEach($Group in ($scope | Where-Object {@("Group","Alias") -contains $_.Trustee.SidType})){
                        $scopedObjects += Get-ADGroupMember $group.Trustee.Name | ForEach-Object {Get-ADObject $_.DistinguishedName}
                    }
                    #Add in users and computers within scope
                    ForEach($object in ($scope | Where-Object {@("user","computer") -contains $_.Trustee.SIDType})){
                        $scopedObjects += Get-ADObject $object.Trustee.DSPath
                    }
                    $scopedObjects = $scopedObjects | Select-Object -Unique
                    ForEach($object in $scopedObjects){
                        Write-Verbose "Scoped object: $($Object.Name)"
                    }
                    #Find objects the GPO applies to
                    Foreach($OU in $OUs){
                        Get-ADObject -SearchBase $ou.DistinguishedName -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Where-Object {$scopedObjects.Name -contains $_.name} | Select-Object Name,ObjectClass
                    }
                }
            }Else{
                Write-Error "GPO has no scope."
            }
        }Else{
            Write-Host "GPO has no links"
        }
    }
    End{}
}

Get-GPO $Name | Get-GPImpact -Verbose

#endregion

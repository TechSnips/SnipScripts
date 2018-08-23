#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region What we need to know

$OU = 'OU=People,DC=techsnips,DC=local'

#Find the linked GPO DistinguishedNames
$LinkedGPOs = Get-ADOrganizationalUnit $OU | Select-Object -ExpandProperty LinkedGroupPolicyObjects
$LinkedGPOs

#Convert them to GUIDs
$LinkedGPOGUIDs = $LinkedGPOs | ForEach-Object{$_.Substring(4,36)}
$LinkedGPOGUIDs

#Return the GPOs from GUIDs
$LinkedGPOGUIDs | ForEach-Object {Get-GPO -Guid $_ | Select-Object DisplayName}
#endregion

#region How to build the function
Function Get-ADOULinkedGPOs{
    [cmdletbinding(
        DefaultParameterSetName = 'OrganizationalUnit'
    )]
    Param(
        [Parameter(
            ParameterSetName = 'OrganizationalUnit',
            ValueFromPipeline = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]$OU,
        [Parameter(
            Position = 0,
            ParameterSetName = 'DistinguishedName',
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$DistinguishedName
    )
    Begin{}
    Process{
        If($PSCmdlet.ParameterSetName -eq 'DistinguishedName'){
            $OU = Get-ADOrganizationalUnit $DistinguishedName
        }
        $LinkedGPOGUIDs = $OU.LinkedGroupPolicyObjects | ForEach-Object{$_.Substring(4,36)}
        ForEach($GUID in $LinkedGPOGUIDs){
            Get-GPO -Guid $GUID
        }
    }
    End{}
}

#Examples
$OU = Get-ADOrganizationalUnit $OU

Get-ADOULinkedGPOs -OU $OU

Get-ADOULinkedGPOs -DistinguishedName $OU.DistinguishedName

Get-ADOrganizationalUnit $OU | Get-ADOULinkedGPOs

Get-ChildItem "AD:\$OU" | Get-ADOULinkedGPOs

#endregion
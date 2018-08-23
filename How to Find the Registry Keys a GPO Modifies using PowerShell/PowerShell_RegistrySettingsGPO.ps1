#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Basic how-to

#GPO to use
$GPOName = 'IT'

#Get-GPRegistryValue usage
Get-GPRegistryValue -Name $GPOName -Key 'HKLM\System'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software\Policies'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software\Policies\Microsoft\FVE'

#endregion

#region Recursive function
#Darren Mar-Elia, aka gpoguy
#https://github.com/gpoguy/ADMXToDSC/blob/master/ADMXToDSC.PS1
#Lines 73-107, Recurse_PolicyKeys

#My rewrite:
Function Get-GPRecursiveRegistryValues{
    [cmdletbinding()]
    Param(
        [string]$GPOName,
        [string]$Key
    )
    $GPORegistryValues = Get-GPRegistryValue -Name $GPOName -Key $Key -ErrorAction SilentlyContinue
    Foreach($item in $GPORegistryValues){
        If ($item.ValueName){
            $item
        }Else{
            Get-GPRecursiveRegistryValues -Key $item.FullKeyPath -GPOName $GPOName
        }
    }
}
#Usage
Get-GPRecursiveRegistryValues -GPOName $GPOName -Key 'HKLM\Software'

Get-GPRecursiveRegistryValues -GPOName $GPOName -Key 'HKCU\Software'

#endregion

#region Make it one function!

#region what we need
$BaseKeys = 'HKLM\System','HKLM\Software','HKCU\Software','HKCU\System'
$GPOName = 'IT'

ForEach($Key in $BaseKeys){
    Get-GPRecursiveRegistryValues -GPOName $GPOName -Key $Key | Format-Table ValueName,KeyPath
}

#endregion

#region function

Function Get-GPAllRegistryValues{
    Param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('DisplayName')]
        [string]$Name
    )
    Begin{
        $BaseKeys = 'HKLM\System','HKLM\Software','HKCU\Software','HKCU\System'
        Function Get-GPRecursiveRegistryValues{
            [cmdletbinding()]
            Param(
                [string]$GPOName,
                [string]$Key
            )
            $GPORegistryValues = Get-GPRegistryValue -Name $GPOName -Key $Key -ErrorAction SilentlyContinue
            Foreach($item in $GPORegistryValues){
                If ($item.ValueName){
                    $item
                }Else{
                    Get-GPRecursiveRegistryValues -Key $item.FullKeyPath -GPOName $GPOName
                }
            }
        }

    }
    Process{
        ForEach($Key in $BaseKeys){
            Get-GPRecursiveRegistryValues -GPOName $Name -Key $Key
        }
    }
    End{}
}

#Usage
#One Policy
Get-GPAllRegistryValues -Name 'IT'

Get-GPO -Name 'IT' | Get-GPAllRegistryValues

#Multiple
Get-GPO -All | Where-Object DisplayName -like 'Default*' | Get-GPAllRegistryValues

#All
Get-GPO -All | Get-GPAllRegistryValues

#endregion

#endregion
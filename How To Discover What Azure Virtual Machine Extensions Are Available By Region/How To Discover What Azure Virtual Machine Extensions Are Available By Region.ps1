#region
Connect-AzureRmAccount
#endregion

#region
Get-AzureRmVmImagePublisher -Location "uksouth" | Get-AzureRmVMExtensionImageType |  Get-AzureRmVMExtensionImage | Select-Object Type, Version

Get-AzureRmVmImagePublisher -Location "uksouth" | Get-AzureRmVMExtensionImageType |  Get-AzureRmVMExtensionImage `
 | Where-Object {$_.Type -like "*Acronis*"} | Select-Object Type, Version 
#endregion

#region
function Find-AzureExtension {
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $location,
        [string]
        $Type
    )

    Begin {
        Write-Verbose "Now retrieving the information on extension $type from $location "
        
    }
    Process {
        try
        {
          Get-AzureRmVmImagePublisher -Location $location  | Get-AzureRmVMExtensionImageType `
            | Get-AzureRmVMExtensionImage | Where-Object {$_.Type -like "*$($Type)*"} | Select-Object Type, Version | Format-Table -AutoSize  
        }
        catch {throw $_}
        
    }
    End {
        Write-verbose "Completed"
    }
}
#endregion

#region
Disconnect-AzureRmAccount
#EndRegion
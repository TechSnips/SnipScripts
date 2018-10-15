Install-Module PoshRSJob

Import-Module PoshRSJob

'1.1.1.1', '1.0.0.1', '8.8.8.8', '8.8.4.4' | Start-RSJob -Name $_ -ScriptBlock {
    [PSCustomObject] @{
        Target = $_
        Response = Test-Connection -ComputerName $_ -Count 4 -Quiet
    }
} | Wait-RSJob | Receive-RSJob

Get-Module PoshRSJob

Remove-Module PoshRSJob

Get-Module PoshRSJob -ListAvailable

Uninstall-Module PoshRSJob
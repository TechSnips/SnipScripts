
#region Using Confirm Parameter
Stop-Process -Name NotePad -Confirm
Stop-Process -Name NotePad -Confirm:$true
Stop-Process -Name NotePad -Confirm:$false
Get-Process -Name NotePad
#endregion

#region Confirm Impact Levels
$ConfirmPreference
function Remove-File {
    [CmdletBinding(
        ConfirmImpact = 'High',    
        SupportsShouldProcess = $true
    )]
    param($file)
    if ($PSCmdlet.ShouldProcess($file)) {
        Remove-Item -Path $file
        Write-Output "$file has been deleted!"
    }
}
Remove-File -File C:\temp\readme.txt
#endregion
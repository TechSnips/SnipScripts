$InformationPreference = 'Continue'
while ($true) {
    $Status = (Get-Service spooler).Status
    if ($Status -eq 'Running') {
        Write-Information "Print Spooler Service is: $Status"
    } else {
        Write-Warning "Print Spooler Service is: $Status"
    }
    Start-Sleep -Seconds 1
}





Start-Sleep -Seconds 5
Stop-Service -Name 'spooler'
Start-Sleep -Seconds 3
Start-Service -Name 'spooler'





Start-Sleep -Seconds 5
$PsProcs = Get-CimInstance Win32_Process -Filter "name = 'powershell_ise.exe'"

foreach ($Proc in $PsProcs) {
    $Owner = Invoke-CimMethod -InputObject $Proc -MethodName GetOwner

    if ($Owner.User -notlike 'admin*') {
        Stop-Process -Id $Proc.ProcessId -Force
    }
}

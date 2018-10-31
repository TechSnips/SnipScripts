
#region Try\Catch\Finally
try {
    Write-Host "Message before the error" -ForegroundColor Cyan
    $file = Get-ChildItem -Path 'C:\ProgramData\TechSnips\Snip.log' -ErrorAction Stop
    Write-Host "Message after the error" -ForegroundColor Cyan
} catch {
    Write-Warning -Message "An exception was caught!"
    Write-Warning -Message "Exception Type: $($_.Exception.GetType().FullName)"
} finally {
    Write-Host "Any clean actions go here" -ForegroundColor Green
}
#endregion

#region Catch Specfic Exception
try {
    Write-Host "Message before the error" -ForegroundColor Cyan
    Get-ChildItem -Path 'C:\ProgramData\TechSnips\Snip.log' -ErrorAction Stop
    Write-Host "Message after the error" -ForegroundColor Cyan
} catch [System.Management.Automation.ItemNotFoundException] {
    New-Item -ItemType File -Path 'C:\ProgramData\TechSnips\Snip.log' -Force
} catch {
    Write-Warning -Message "Uknown exception was caught!"
    Write-Warning -Message "Exception Type: $($_.Exception.GetType().FullName)"
} finally {
    Write-Host "Any clean actions go here" -ForegroundColor Green
}
#endregion

#region Multiple Exception Types
try {
    $file = Get-ChildItem C:\ProgramData\TechSnips\Snip.Log -ErrorAction Stop
    Get-Conten -ErrorAction Stop
} catch [System.Management.Automation.ItemNotFoundException] {
    New-Item -ItemType File -Path 'C:\ProgramData\TechSnips\Snip.log' -Force
} catch [System.Management.Automation.CommandNotFoundException] {
    Write-Warning -Message "Check command name!"
} catch {
    Write-Warning -Message "Uknown exception was caught!"
    Write-Warning -Message "Exception Type: $($_.Exception.GetType().FullName)"
} finally {
    Write-Host "Any clean actions go here" -ForegroundColor Green
}
#endregion
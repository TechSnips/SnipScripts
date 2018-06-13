<#======================================================================================================================
Query Windows Event Log Using Get-EventLog PowerShell cmdlet
  TechSnips - https://www.techsnips.io/playing/how-to-query-the-windows-event-log-using-the-get-eventlog-powershell-cmdlet-coming-soon
  GitHub - https://github.com/TechSnips/SnipScripts
========================================================================================================================
  References & Prerequisites: None
======================================================================================================================#>

Get-EventLog -LogName Application

Get-EventLog -LogName Application -Newest 15

Get-EventLog -LogName Application -Newest 15 -EntryType Error

Get-EventLog -LogName Application -Newest 15 -EntryType Error | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize
Get-EventLog -LogName System -Newest 15 -EntryType Error | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize

"Application","System" | ForEach-Object {Get-EventLog -LogName $_ -Newest 15 -EntryType Error} | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize

#Here is a list of commands that were executed throughout the video

Get-EventLog -LogName Application

Get-EventLog -LogName Application -Newest 15

Get-EventLog -LogName Application -Newest 15 -EntryType Error

Get-EventLog -LogName Application -Newest 15 -EntryType Error | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize
Get-EventLog -LogName System -Newest 15 -EntryType Error | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize

"Application","System" | ForEach-Object {Get-EventLog -LogName $_ -Newest 15 -EntryType Error} | Select-Object TimeWritten, Source, Message | Format-Table -AutoSize
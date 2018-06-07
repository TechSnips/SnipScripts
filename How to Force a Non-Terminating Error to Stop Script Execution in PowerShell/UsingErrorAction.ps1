
#region Force Non-Terminating to Inquire
Get-ChildItem -Path c:\temp\readme.txt, C:\temp\test.log
$ErrorActionPreference
Get-ChildItem -Path c:\temp\readme.txt, C:\temp\test.log -ErrorAction Inquire
#endregion

#region Force Non-Terminating to Stop
Get-ChildItem -Path c:\temp\readme.txt, C:\temp\test.log
Get-ChildItem -Path c:\temp\readme.txt, C:\temp\test.log -ErrorAction Stop
#endregion

#region Handling Non-Terminating Errors
'c:\temp\readme.txt', 'C:\temp\test.log' | ForEach-Object -Process {
    try {
        Get-ChildItem $_ -ErrorAction Stop
    } catch {
        New-Item -Name readme.txt -Path C:\temp
    }
}
#endregion
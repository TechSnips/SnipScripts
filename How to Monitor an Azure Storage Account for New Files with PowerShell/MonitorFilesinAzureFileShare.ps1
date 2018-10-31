<#
    Prerequisites:
        Azure Subscription
        Storage Account 
    Snip suggestions:
        N/A
    Notes:
#>

#region

#Insert Commands from Azure Portal here

#endregion

#region
# Create some test files in Azure Files
1..5 | % { New-Item -Path p:\ -Name "$_.txt" -Value (Get-Date).toString()-ItemType file} 

$OlderThan = 5
$Files =  Get-ChildItem -file -Recurse "p:\" | Where-Object {$_.CreationTime -gt (Get-Date).AddMinutes(-$OlderThan)}
#endregion

#region
foreach ($file in $files) {Write-host "$($file.Fullname) was created at $($file.CreationTime)" -ForegroundColor Green}
#endregion

#region
#Output to Windows Event Log
foreach ($file in $files)
    {
        Write-Eventlog -LogName Ipswitch -Source snip -EventId 2000 -EntryType Information -Message "$($file.Fullname) was created at $($file.CreationTime)"
    }
#endregion

#region
#Output to Log File
New-Item -Path E:\Ipswitch -Name AzureNewFileLog.txt -ItemType File -Force
foreach ($file in $files)
    {
       Add-Content -Path E:\Ipswitch\AzureNewFileLog.txt -Value "$($file.Fullname) was created at $($file.CreationTime)"       
    }
notepad E:\Ipswitch\AzureNewFileLog.txt
#endregion

#region
Remove-PSDrive P -Force
#endregion
<#
    Prerequisites:
    N/A
#>

#region
 $watcher = New-Object System.IO.FileSystemWatcher
 $watcher.IncludeSubdirectories = $true
 $watcher.Path = 'e:\Ipswitch\'
 $watcher.EnableRaisingEvents = $true
#endregion

#region
$action =
    {
        $path = $event.SourceEventArgs.FullPath
        $changetype = $event.SourceEventArgs.ChangeType
        Write-Eventlog -LogName Ipswitch -Source snip -EventId 10000 -EntryType Information -Message "$path was $changetype at $(get-date)"
    }
#endregion

#region
Register-ObjectEvent $watcher "Created" -Action $action -
New-Item -path E:\ipswitch\test.txt -ItemType File
#endregion

#region
Get-EventSubscriber
Unregister-Event -SubscriptionId 8
#endregion
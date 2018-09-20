#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region prep

#region using get-winevent -FilterHashtable

#Get events from the security event log
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    StartTime = (Get-Date).AddHours(-1)
    EndTime = Get-Date
}

#Remote computer
Get-WinEvent -ComputerName EX01 -FilterHashtable @{
    LogName = 'System'
    StartTime = (Get-Date).AddHours(-1)
    EndTime = Get-Date
}

#endregion

#region searching all logs

#Retrieve a list of all log names
Get-WinEvent -ListLog *

ForEach($log in Get-WinEvent -ListLog *){
    Get-WinEvent -FilterHashtable @{
        LogName = $log.LogName
        StartTime = (Get-Date).AddHours(-1)
        EndTime = Get-Date
    }
}

#endregion

#region filtering for certain event logs

$skipEventLogs = 'Security','System'

$LogsToSearch = Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -and ($skipEventLogs -notcontains $_.LogName)} | Select-Object -ExpandProperty LogName

$LogsToSearch

#endregion

#endregion

#region script demo

#region variables

#Computers to search
$ComputerName = 'DC01','EX01'

#Timeframe to search between
$StartTimeStamp = (Get-Date).AddHours(-1)
$EndTimeStamp = Get-Date

#Logs to skip OR include separated by commas - Choose one or neither
$includeEventLogs = 'System','Application'
#OR
$skipEventLogs = ''

#Output file path
$OutputFilePath = 'C:\eventlogs.txt'

#endregion

#Index variable
$ComputerCount = 0

ForEach($Computer in $ComputerName){
    $ComputerCount++
    Write-Progress -Activity "Processing computers" -Status "Processing $Computer" -PercentComplete ($ComputerCount/$ComputerName.Count*100) -Id 0

    If($includeEventLogs){
        $LogsToSearch = $includeEventLogs
    }Else{
        $LogsToSearch = Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -and ($skipEventLogs -notcontains $_.LogName)} | Select-Object -ExpandProperty LogName
    }

    #Index variable
    $logCount = 0

    ForEach ($log in $LogsToSearch){    
        $logCount++
        Write-Progress -Activity 'Processing logs' -Status "Processing $log" -PercentComplete ($logCount/$LogsToSearch.Count*100) -ParentId 0 -Id 1
        
        #Query
        Get-WinEvent -ComputerName $Computer -FilterHashtable @{
            'LogName' = $log
            'StartTime' = $StartTimeStamp
            'EndTime' = $EndTimeStamp    
        } | Out-File -FilePath $OutputFilePath -Append -Force
    }
    Write-Progress -Activity 'Processing logs' -Id 1 -Completed
}
#endregion
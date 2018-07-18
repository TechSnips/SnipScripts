#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region prep

#Get events from one computer
Get-WinEvent -LogName System -MaxEvents 5

#Remote computer
Get-WinEvent -ComputerName EX01 -LogName Security -MaxEvents 5

#endregion

#region FilterHashtable

#region Get events by level
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    Level = 1,2 # 1 Critical, 2 Error, 3 Warning, 4 Information
}
#endregion

#region Get account lockouts
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4740
}
#endregion

#region Get events by provider
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Microsoft-Windows-GroupPolicy'
}
#endregion

#endregion

#region script demo

#region Computers to search
$ComputerName = 'DC01','EX01'
ForEach($Computer in $ComputerName){    
    Get-WinEvent -ComputerName $Computer -FilterHashtable @{
        LogName = 'System'
        Level = 1,2 # 1 Critical, 2 Error, 3 Warning, 4 Information
    }
}
#endregion

#region Get lockouts from domain controllers
$ComputerName = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name
ForEach($Computer in $ComputerName){
    Get-WinEvent -ComputerName $Computer -FilterHashtable @{
        LogName = 'Security'
        ID = 4740
    }
}
#endregion

#region Get all group policy errors
$ComputerName = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
ForEach($Computer in $ComputerName){
    Get-WinEvent -ComputerName $Computer -FilterHashtable @{
        LogName = 'System'
        ProviderName = 'Microsoft-Windows-GroupPolicy'
        Level = 1,2 # 1 Critical, 2 Error, 3 Warning, 4 Information
    }
}
#endregion

#region Output to csv for usefulness
$output = @()
$ComputerName = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
ForEach($Computer in $ComputerName){
    $events = Get-WinEvent -ComputerName $Computer -FilterHashtable @{
        LogName = 'System'
        ProviderName = 'Microsoft-Windows-GroupPolicy'
        Level = 1,2 # 1 Critical, 2 Error, 3 Warning, 4 Information
    }
    ForEach($event in $events){
        $output += $event | Add-Member -NotePropertyName 'ComputerName' -NotePropertyValue $Computer -PassThru
    }
}
$output | Export-Csv C:\Temp\Events.csv -NoTypeInformation
#endregion
#endregion
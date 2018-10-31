#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Info you need to know

#region Initial stuff

#Test Account
$user = 'User001'

#Account lockout Event ID
$LockOutID = 4740

#Find the PDC
(Get-ADDomain).PDCEmulator
$PDCEmulator = (Get-ADDomain).PDCEmulator

#Query event log
Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
    LogName = 'Security'
    ID = $LockOutID
}

#endregion

#region Parse the event
$Events = Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
    LogName = 'Security'
    ID = $LockOutID
}

$Events[0].Message

$Events[0].Properties

#Username
$Events[0].Properties[0].Value

#Source computer (Caller Computer)
$Events[0].Properties[1].Value

#For all events
ForEach($event in $Events){
    [pscustomobject]@{
        UserName = $event.Properties[0].Value
        CallerComputer = $event.Properties[1].Value
        TimeStamp = $event.TimeCreated
    }
}

#endregion

#endregion

#region Make it a function!

Function Get-ADUserLockoutSource {
    Param (
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Name')]
        [string]$SamAccountName
    )
    Begin{
        $PDCEmulator = (Get-ADDomain).PDCEmulator
    }
    Process{
        $Events = Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
            LogName = 'Security'
            ID = $LockOutID
        } | Where-Object {$_.Properties[0].Value -eq $SamAccountName}
        ForEach($event in $Events){
            [pscustomobject]@{
                UserName = $event.Properties[0].Value
                CallerComputer = $event.Properties[1].Value
                TimeStamp = $event.TimeCreated
            }
        }
    }
    End{}
}

#Examples
Get-ADUserLockoutSource -SamAccountName $user

Search-ADAccount -LockedOut | Get-ADUserLockoutSource

$csvPath = 'C:\users\TechSnips\Desktop\UserLockout.csv'
Search-ADAccount -LockedOut | Get-ADUserLockoutSource | Export-Csv $csvPath -NoTypeInformation -Force
. $csvPath

#endregion
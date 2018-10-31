#region demo
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
Function Get-DBPathStats{
    $DBPath = Get-Item 'E:\ExDBs'
    $DBPath | Get-ChildItem | Measure-Object -Sum Length | Select-Object @{Name="Path"; Expression={$DBPath.FullName}},@{Name="Files"; Expression={$_.Count}},@{Name="Size"; Expression={"$($_.Sum/1MB) MB"}}
}
#endregion

#region clean
Function Prompt(){}
Clear-Host
$MailboxDatabase = 'TechSnipsDemoDB'
If((Get-MailboxDatabase $MailboxDatabase).CircularLoggingEnabled){
    Set-MailboxDatabase $MailboxDatabase -CircularLoggingEnabled $false
    Restart-Service 'MSExchangeIS'
}
#endregion

#region generate logs
$str = 'abcdefghijklmnopqrstuvwxyz'
For($x=0;$x-lt26;$x++){
    Remove-Mailbox "$($str[$x])" -Confirm:$false
    New-Mailbox -Name "$($str[$x])" -Room
    For($y=0;$y-lt50;$y++){
        Send-MailMessage -To "$($str[$x])@techsnipsdemo.org" -Body "$y $(Get-Random ($str -split '' | ?{$_}))" -From sysah@techsnipsdemo.org -SmtpServer ex01.techsnipsdemo.org -subject "$y $(Get-Random ($str -split '' | ?{$_}))"
    }
    Remove-Mailbox "$($str[$x])$($str[$x])" -Confirm:$false
    New-Mailbox -Name "$($str[$x])$($str[$x])" -Room
    For($y=0;$y-lt50;$y++){
        Send-MailMessage -To "$($str[$x])$($str[$x])@techsnipsdemo.org" -Body "$y $(Get-Random ($str -split '' | ?{$_}))" -From sysah@techsnipsdemo.org -SmtpServer ex01.techsnipsdemo.org -subject "$y $(Get-Random ($str -split '' | ?{$_}))"
    }
}
#endregion

#region demo
$MailboxDatabase = 'TechSnipsDemoDB'

Get-DBPathStats

Set-MailboxDatabase $MailboxDatabase -CircularLoggingEnabled $true

Restart-Service 'MSExchangeIS'

Get-DBPathStats
#endregion
#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
$WarningPreference = 'SilentlyContinue'
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region simple

#Get the size of one mailbox
Get-MailboxStatistics 'Anthony Howell' | Select-Object -Property DisplayName,TotalItemSize

#Get the sizes of all mailboxes
Get-Mailbox | Get-MailboxStatistics -WarningAction SilentlyContinue | Format-Table DisplayName,TotalItemSize

#Sort them by size
Get-Mailbox | Get-MailboxStatistics -WarningAction SilentlyContinue | `
Sort-Object -Property TotalItemSize | Format-Table DisplayName,TotalItemSize

#All mailboxes in a database, sorted
Get-Mailbox -Database 'TechSnipsDemoDB' | Get-MailboxStatistics -WarningAction SilentlyContinue | `
Sort-Object -Property TotalItemSize | Format-Table DisplayName,TotalItemSize

#endregion

#region Get all mailbox sizes and export to CSV
$Properties = 'DisplayName','TotalItemSize','ItemCount','TotalDeletedItemSize','DeletedItemCount'

Get-Mailbox | Get-MailboxStatistics -WarningAction SilentlyContinue | Sort-Object -Property TotalItemSize | `
Select-Object $Properties | Export-Csv 'C:\temp\Mailboxes.csv' -NoTypeInformation

#endregion

#region Sum all mailbox sizes
((Get-MailboxStatistics 'Anthony Howell').TotalItemSize | Get-Member).TypeName[0]

(Get-MailboxStatistics 'Anthony Howell').TotalItemSize.Value.ToBytes()

$Size = (Get-Mailbox | Get-MailboxStatistics -WarningAction SilentlyContinue).TotalItemSize.Value.ToBytes() | `
Measure-Object -Sum

$size

$size.Sum/1mb

#endregion

#endregion
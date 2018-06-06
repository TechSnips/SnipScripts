#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
$CASMailbox = @{
    'Identity' = 'Jerry Smith'
    'ActiveSynceEnabled' = $true
    'PopEnabled' = $true
    'ImapEnabled' = $true
    'MapiEnabled' = $true
    'OWAEnabled' = $true
}
Get-Mailbox | Set-CASMailbox -OWAEnabled $true
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#Get current protocol settings
Get-CASMailbox -Identity 'Jerry Smith'

#Set a mailbox's settings
$CASMailbox = @{
    'Identity' = 'Jerry Smith'
    'ActiveSynceEnabled' = $false
    'PopEnabled' = $false
    'ImapEnabled' = $false
}
Set-CASMailbox -Identity 'Jerry Smith'

#Set all mailboxes
Get-Mailbox | Set-CASMailbox -OWAEnabled $false

Get-CASMailbox | Group-Object OWAEnabled

#endregion
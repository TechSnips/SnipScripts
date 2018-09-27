#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
$unlimiteddb = @{
    'Identity' = 'TechSnipsDemoDB'
    'IssueWarningQuota' = 'Unlimited'
    'ProhibitSendQuota' = 'Unlimited'
    'ProhibitSendReceiveQuota' = 'Unlimited'
}
Set-MailboxDatabase @unlimiteddb
$unlimitedmb = @{
    'Identity' = 'Roy Trenneman'
    'IssueWarningQuota' = 'Unlimited'
    'ProhibitSendQuota' = 'Unlimited'
    'ProhibitSendReceiveQuota' = 'Unlimited'
    'UseDatabaseQuotaDefaults' = $true
}
Set-Mailbox @unlimitedmb
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region database

$MailboxDatabase = 'TechSnipsDemoDB'

#Get current quotas
Get-MailboxDatabase -Identity $MailboxDatabase | Format-List Issue*Quota,Prohibit*Quota

$DatabaseQuota = @{
    'Identity' = $MailboxDatabase
    'IssueWarningQuota' = '1GB'
    'ProhibitSendQuota' = '1.25GB'
    'ProhibitSendReceiveQuota' = '1.5GB'
}

#Set new quotas
Set-MailboxDatabase @DatabaseQuota

#Get new quotas
Get-MailboxDatabase -Identity $MailboxDatabase | Format-List Issue*Quota,Prohibit*Quota

#endregion

#region mailbox

$Mailbox = 'Roy Trenneman'

#Get current quotas
Get-Mailbox -Identity $Mailbox | Format-List Issue*Quota,Prohibit*Quota,UseDatabaseQuotaDefaults

#Get the mailbox's database quotas
Get-MailboxDatabase (Get-Mailbox -Identity $Mailbox).Database | Format-List Issue*Quota,Prohibit*Quota

$MailboxQuota = @{
    'Identity' = $Mailbox
    'IssueWarningQuota' = '10GB'
    'ProhibitSendQuota' = '12GB'
    'ProhibitSendReceiveQuota' = 'Unlimited'
    'UseDatabaseQuotaDefaults' = $false
}

#Set new quotas
Set-Mailbox @MailboxQuota

#Get new quotas
Get-Mailbox -Identity $Mailbox | Format-List Issue*Quota,Prohibit*Quota,UseDatabaseQuotaDefaults

#endregion

#endregion
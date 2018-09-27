#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
New-Mailbox 'Million Ants' -UserPrincipalName millionants@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Alan Rails' -UserPrincipalName alanrails@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Crocubot' -UserPrincipalName crocubot@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'SuperNova' -UserPrincipalName supernova@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Noob-Noob' -UserPrincipalName noob-noob@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-MailContact -Name WorldEnder -ExternalEmailAddress worldender@supervilliansrus.biz
New-DistributionGroup Everybody
Get-Mailbox | %{Add-DistributionGroupMember Everybody -Member $_}
#endregion

#region clean
Remove-DistributionGroup 'Vindicators' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region Create a distribution group
New-DistributionGroup -Name 'Vindicators'

#endregion

#region Remove a distributuon group
Remove-DistributionGroup -Identity 'Vindicators' -Confirm:$false

#endregion

#region Create a complex distribution group
$DistroGroup = @{
    'Name' = 'Vindicators'
    'Type' = 'Security' # Creates mail-enabled security group instead of Distribution group
    'PrimarySMTPAddress' = 'vindicators@techsnipsdemo.org'
    'ModeratedBy' = 'SuperNova'
    'ModerationEnabled' = $true
    'Members' = 'SuperNova'
}
New-DistributionGroup @DistroGroup

#Look at the new group in AD
Get-ADGroup 'CN=Vindicators,CN=Users,DC=techsnipsdemo,DC=org'

#endregion

#region Members

#Add members to a distribution group
Add-DistributionGroupMember -Identity 'Vindicators' -Member 'Million Ants'
Add-DistributionGroupMember -Identity 'Vindicators' -Member 'Alan Rails'
Add-DistributionGroupMember -Identity 'Vindicators' -Member 'Crocubot'
Add-DistributionGroupMember -Identity 'Vindicators' -Member 'Noob-Noob'

#Forget that, use the pipeline
'Million Ants','Alan Rails','Crocubot','Noob-Noob' | ForEach-Object `
{Add-DistributionGroupMember -Identity 'Vindicators' -Member $_}

Get-DistributionGroupMember -Identity 'Vindicators'

#Remove members from a disttribution group
Remove-DistributionGroupMember -Identity 'Vindicators' -Member 'Million Ants'
Remove-DistributionGroupMember -Identity 'Vindicators' -Member 'Alan Rails'
Remove-DistributionGroupMember -Identity 'Vindicators' -Member 'Crocubot'

'Million Ants','Alan Rails','Crocubot' | ForEach-Object `
{Remove-DistributionGroupMember -Identity Vindicators -Member $_ -Confirm:$false}

Get-DistributionGroupMember -Identity 'Vindicators'

#endregion

#region Edit

#Configure a distribution group
$DistroSettings = @{
    'Identity' = 'Vindicators'
    'RequireSenderAuthenticationEnabled' = $false
    'AcceptMessagesOnlyFromSendersOrMembers' = 'Everybody@techsnipsdemo.org','WorldEnder@SuperVilliansRus.biz'
}
Set-DistributionGroup @DistroSettings

Get-MailContact WorldEnder

#endregion

#endregion
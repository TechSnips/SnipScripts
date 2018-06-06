#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
New-Mailbox 'Hubert Farnsworth' -UserPrincipalName HubertFarnsworth@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-DistributionGroup 'Accounting'
#endregion

#region clean
Get-TransportRule | Remove-TransportRule -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region Creating transport rules

#https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance/New-TransportRule?view=exchange-ps

#region Tag inbound emails
$TransportRule = @{
    'Name' = 'Tag External'
    'FromScope' = 'NotInOrganization'
    'PrependSubject' = '[External] '
}
New-TransportRule @TransportRule

Get-TransportRule $TransportRule.Name | Select-Object -Property Description | Format-List

#endregion

#region Disclaim outbound emails
$TransportRule = @{
    'Name' = 'Disclaimer'
    'FromScope' = 'InOrganization'
    'SentToScope' = 'NotInOrganization'
    'ApplyHtmlDisclaimerText' = 'Forwarding this message is punishable by 10 lashes per forwarded recipient.'
    'ApplyHtmlDisclaimerLocation' = 'Append' #Prepend
    'ApplyHtmlDisclaimerFallbackAction' = 'Wrap' #Ignore, Reject
}
New-TransportRule @TransportRule

Get-TransportRule $TransportRule.Name | Select-Object -Property Description | Format-List

#endregion

#region CC Accounting with exceptions
$TransportRule = @{
    'Name' = 'CC Accounting on invoices and POs'
    'FromScope' = 'NotInOrganization'
    'SentToScope' = 'InOrganization'
    'SubjectContainsWords' = 'Invoice','Purchase Order'
    'CopyTo' = 'Accounting@TechSnipsDemo.org'
    'ExceptIfSentToMemberOf' = 'Accounting' #Distribution Group or Security Group
    'ExceptIfMessageTypeMatches' = 'Calendaring'
    #OOF,AutoForward,Encrypted,PermissionControlled,Voicemail,Signed,ApprovalRequest,ReadReceipt
}
New-TransportRule @TransportRule

Get-TransportRule $TransportRule.Name | Select-Object -Property Description | Format-List

#endregion

#endregion

#region Managing transport rules

#https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance/set-transportrule?view=exchange-ps

#region Priority

#Set Priority
Get-TransportRule

#Set disclaimer to top priority
Set-TransportRule -Identity 'Disclaimer' -Priority 0

Get-TransportRule

#endregion

#region Modifying

#Set tag external to except the IT Department
Set-TransportRule -Identity 'Tag External' -ExceptIfSentToMemberOf 'IT Department'

Get-TransportRule -Identity 'Tag External' | Select-Object -Property Description | Format-List

#Disable/Enable
Disable-TransportRule -Identity 'CC Accounting on Invoices and POs' -Confirm:$false

Get-TransportRule

Enable-TransportRule -Identity 'CC Accounting on Invoices and POs'

#endregion

#region Remove a transport rule
Remove-TransportRule -Identity 'Disclaimer' -Confirm:$false

Get-TransportRule

#endregion

#endregion

#endregion
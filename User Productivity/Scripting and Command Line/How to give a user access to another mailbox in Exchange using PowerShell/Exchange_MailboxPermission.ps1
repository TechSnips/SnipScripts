#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-MailboxPermission -Identity "Jack O'Neill" -User 'George Hammond' -AccessRights FullAccess -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#Get current permissions
Get-MailboxPermission -Identity "Jack O'Neill" | Where-Object IsInherited -eq $false

#Add full access
Add-MailboxPermission -Identity "Jack O'Neill" -User 'George Hammond' -AccessRights FullAccess

Get-MailboxPermission -Identity "Jack O'Neill" | Where-Object IsInherited -eq $false

#Possible permissions: FullAccess, SendAs, ExternalAccount, DeleteItem, ReadPermission, ChangePermission, ChangeOwner

#Remove access
Remove-MailboxPermission -Identity "Jack O'Neill" -User 'George Hammond' -AccessRights FullAccess

#Add read permission
Add-MailboxPermission -Identity "Jack O'Neill" -User 'George Hammond' -AccessRights ReadPermission

#endregion
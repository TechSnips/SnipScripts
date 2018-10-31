#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-Mailbox 'Ship' -Confirm:$false
Remove-Mailbox 'Smell-O-Scope' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

#region Create resource mailboxes

#Create a room mailbox
$RoomMailbox = @{
    'Room' = $true
    'Name' = 'Ship'
    'DisplayName' = 'Planet Express Ship'
}
New-Mailbox @RoomMailbox

Get-ADUser -Identity 'Ship'

#Create an equipment mailbox
$EquipmentMailbox = @{
    'Equipment' = $true
    'Name' = 'Smell-O-Scope'
    'DisplayName' = 'Smell-O-Scope'
}
New-Mailbox @EquipmentMailbox

Get-ADUser -Identity 'Smell-O-Scope'

#endregion

#region Set calendar processing

#Set it on our room
$RoomCalendarProcessing = @{
    'Identity' = 'Ship@techsnipsdemo.org'
    'AutomateProcessing' = 'AutoAccept'
    'BookingWindowInDays' = 365
    'DeleteAttachments' = $false
}
Set-CalendarProcessing @RoomCalendarProcessing

Get-CalendarProcessing 'Ship'

#Set it on our equipment
$EquipmentCalendarProcessing = @{
    'Identity' = 'Smell-O-Scope@techsnipsdemo.org'
    'AutomateProcessing' = 'None'
    'ForwardRequestsToDelegates' = $true
    'ResourceDelegates' = 'Hubert Farnsworth'
}
Set-CalendarProcessing @EquipmentCalendarProcessing

Get-CalendarProcessing 'Smell-O-Scope'

#endregion

#removing
Remove-Mailbox -Identity 'Ship' -Confirm:$false

#endregion
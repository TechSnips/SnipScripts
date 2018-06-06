#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-MoveRequest -Identity 'Anthony Howell' -Confirm:$false
If((Get-Mailbox -Identity 'Anthony Howell').Database -eq 'TechSnipsDemoDB'){
    New-MoveRequest 'Anthony Howell' -TargetDatabase 'Mailbox Database 1384644361'
    While((Get-MoveRequest -Identity 'anthony howell').Status -ne 'Completed'){
        Start-Sleep -Seconds 2
    }
}
Remove-MoveRequest -Identity 'Anthony Howell' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region move a mailbox

#Get the current DB of the mailbox
Get-Mailbox -Identity 'Anthony Howell' | Select-Object -Property Database

#Create a move request
New-MoveRequest -Identity 'Anthony Howell' -TargetDatabase TechSnipsDemoDB

#Check the status of the move request
Get-MoveRequest -Identity 'Anthony Howell'

#Remove when finished
Remove-MoveRequest -Identity 'Anthony Howell' -Confirm:$false

#Verify the new DB
Get-Mailbox -Identity 'Anthony Howell' | Select-Object -Property Database

#endregion

#endregion
#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Function Prompt(){}
Clear-Host
Set-MailboxAutoReplyConfiguration -Identity 'Maurice Moss' -AutoReplyState Disabled -InternalMessage '' -ExternalMessage ''
#endregion

#region demo

Get-PSSession

#region active

$Enabled = @{
    'Identity' = 'Maurice Moss'
    'AutoReplyState' = 'Enabled'
    'ExternalAudience' = 'All' #'None', 'All', 'Known'
    'InternalMessage' = 'I am currently out of the office binge watching TechSnips.io. Please contact Jen Barber for assistance.'
    'ExternalMessage' = 'I am currently out of the office.'
}

#Set auto reply config
Set-MailboxAutoReplyConfiguration @Enabled

#Get auto reply config
Get-MailboxAutoReplyConfiguration $Enabled.Identity | Select-Object Identity,AutoReplyState,ExternalAudience,InternalMessage,ExternalMessage | Format-List

Send-MailMessage -To 'MauriceMoss@techsnipsdemo.org' -From 'sysah@techsnipsdemo.org' -Subject 'This is a demo message 1' -SmtpServer ex01.techsnipsdemo.org

#endregion

#region scheduled

#create HTML formatted message
$MessageHTML = @"
<html>
    <head>
        <style type="text/css" style="display:none">
            <!--
                p
                {margin-top:0;
                margin-bottom:0}
            -->
        </style>
    </head>
    <body dir="ltr">
        <div id="divtagdefaultwrapper" dir="ltr" style="font-size:12pt; color:#000000; font-family:Calibri,Helvetica,sans-serif">
            <p><strong>Hello!</strong></p>
            <p><br></p>
            <p>I am out of the office binge watching snips on <a href="https://techsnips.io">TechSnips.io</a>. Please reach out to Jen Barber until I finish.</p>
            <p><br></p>
            <p>Thanks,</p>
            <p><em>Maurice</em><br></p>
        </div>
    </body>
</html>
"@

$Scheduled = @{
    'Identity' = 'Maurice Moss'
    'AutoReplyState' = 'Scheduled'
    'StartTime' = (Get-Date)
    'EndTime' = (Get-Date).AddDays(7)
    'InternalMessage' = $MessageHTML
    'ExternalAudience' = 'Known'
    'ExternalMessage' = $MessageHTML
}

#Set auto reply config
Set-MailboxAutoReplyConfiguration @Scheduled

#Get auto reply config
Get-MailboxAutoReplyConfiguration $Scheduled.Identity | Select-Object Identity,AutoReplyState,ExternalAudience,InternalMessage,ExternalMessage,StartTime,EndTime | Format-List

Send-MailMessage -To 'MauriceMoss@techsnipsdemo.org' -From 'sysah@techsnipsdemo.org' -Subject 'This is a demo message 2' -SmtpServer ex01.techsnipsdemo.org

#endregion

#endregion
#Connect to SkypeOnline PowerShell module
$creds = Get-Credential
$SfBOsession = New-CsOnlineSession -Credential $creds
Import-PSSession  $SfBOsession 

#Get the current Messaging policies
Get-CsTeamsMessagingPolicy | Select-Object Identity

#Retrieve Messaging policies properties
$NewMessagingPolicy = New-CsTeamsMessagingPolicy -Identity "NewMessagingPolicy - No GIFs"-AllowGiphy $false

#Check the policy has been created
Get-CsTeamsMessagingPolicy | Select-Object Identity

#Assign the new Messaging policy to multiple users
$UsersFile = Import-Csv -Path <YOUR_CSV_LOCATION>

foreach ($User in $UsersFile) {
    Grant-CsTeamsMessagingPolicy -Identity $User.UPN -PolicyName $NewMessagingPolicy.Identity
}


























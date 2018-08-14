#Connect to SkypeOnline PowerShell module
$creds = Get-Credential
$SfBOsession = New-CsOnlineSession -Credential $creds
Import-PSSession  $SfBOsession 

#Get the current Meeting policies
Get-CsTeamsMeetingPolicy | Select-Object Identity

#Retrieve Meeting policies properties
$NewMeetingPolicy = New-CsTeamsMeetingPolicy -Identity "NewMeetingPolicy1" -AllowChannelMeetingScheduling $false -ScreenSharingMode Disabled -AutoAdmittedUsers EveryoneInCompany

#Check the policy has been created
Get-CsTeamsMeetingPolicy | Select-Object Identity

#Assign the new Meeting policy to multiple users
$UsersFile = Import-Csv -Path <YOUR_CSV_LOCATION>

foreach ($User in $UsersFile) {
    Grant-CsTeamsMeetingPolicy -Identity $User.UPN -PolicyName $NewMeetingPolicy.Identity
}
















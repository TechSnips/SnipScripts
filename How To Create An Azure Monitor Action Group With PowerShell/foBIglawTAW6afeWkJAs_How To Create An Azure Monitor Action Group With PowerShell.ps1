
#Connect-AzureRmAccount

Get-AzureRmActionGroup | Select-Object Name

$FranksEmail = New-AzureRmActionGroupReceiver -Name NotifyFrank -EmailReceiver -EmailAddress 'frank_xxx_snips@outlook.com'

$FranksSMS = New-AzureRmActionGroupReceiver -Name 'FranksSMS' -SmsReceiver -CountryCode '44' -PhoneNumber '5555555555'

Set-AzureRmActionGroup -Name 'NotifyFrank' -ResourceGroupName 'MattBrowne_RG' -ShortName 'Frank' -Receiver $FranksEmail, $FranksSMS
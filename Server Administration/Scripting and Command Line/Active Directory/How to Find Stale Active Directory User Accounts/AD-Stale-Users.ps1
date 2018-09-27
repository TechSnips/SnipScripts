# An account is stale if:
#   It is disabled, or
#   The password has expired, or
#   The password has not been reset recently, or
#   It has not been used to log in recently

$MaxAge = 90
$Threshold = (Get-Date).AddDays(-$MaxAge)
 
$StaleUsers = Get-AdUser -Filter * -Properties PasswordLastSet, LastLogonDate, PasswordExpired |
    where {
        $_.Enabled -eq $false -or
        $_.PasswordExpired -eq $true -or
        $_.PasswordLastSet -le $Threshold -or 
        $_.LastLogonDate -le $Threshold        
}

$StaleUsers | Select SamAccountName
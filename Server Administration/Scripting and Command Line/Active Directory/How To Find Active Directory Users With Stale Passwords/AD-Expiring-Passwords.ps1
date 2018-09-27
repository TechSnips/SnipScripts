$Users = Get-ADUser -Filter {Enabled -eq $true} -Properties 'msDS-UserPasswordExpiryTimeComputed'

# $Users.'msDS-UserPasswordExpiryTimeComputed' | Select -First 1
# [datetime]::FromFileTime($Users[0].'msDS-UserPasswordExpiryTimeComputed')

$Expiring = foreach ($User in $Users) {
    $Expiry = [datetime]::FromFileTime($User.'msDS-UserPasswordExpiryTimeComputed')
    $TimeToGo = New-TimeSpan -Start (Get-Date) -End $Expiry
    
    if ($TimeToGo.Days -le 3) {
        [PSCustomObject] @{
            Name = $User.Name
            SamAccountName = $User.SamAccountName
            ExpiryDate = $Expiry
        }
    }
}

$Expiring | Export-Csv -Path D:\Reports\Expiry.csv -NoTypeInformation

. D:\Reports\Expiry.csv
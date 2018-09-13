[System.Web.Security.Membership]::GeneratePassword(8,0)


$PasswordLength = '8'
$NonAlphaNumeric ='0'
$CreateSecurePassword = [System.Web.Security.Membership]::GeneratePassword($PasswordLength,$NonAlphaNumeric)

$CreateSecurePassword
$CreateSecurePassword.Length




#region Functionize
function NewRandomPassword
{
    [cmdletbinding()]
 
    Param (
        [parameter()]
        [ValidateRange(1, 128)]
        [Int]$PasswordLength = 15,
        [parameter()]
        [Int]$NonAlphaNumeric = 0
    )
    If ($NonAlphaNumeric -gt $PasswordLength)
    {
        Write-Warning ("NonAlphaNumeric ({0}) cannot be greater than the PasswordLength ({1})! No password created!" -f
            $NonAlphaNumeric, $PasswordLength)
        Break
    }
    
    $NewSecurePwd = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $NonAlphaNumeric)
    return $NewSecurePwd
}


$CreateSecurePassword = NewRandomPassword -PasswordLength 8
$CreateSecurePassword



#endregion Functionize




# In case of error  add "Add-Type -AssemblyName System.Web" to NewRandomPassword function
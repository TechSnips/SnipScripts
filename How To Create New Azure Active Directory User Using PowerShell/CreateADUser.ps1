# Task: How to create a user in Azure AD, Using Powershell
# Snip requires that the AzureAD module is installed

#Steps to connect
Connect-MsolService
Connect-AzureAD

# Confirm connection
Get-AzureADUser


#Generate PasswordProfile
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "8U@3e0Xd"

#Splat the Parameters!
$params = @{
    AccountEnabled = $true
    DisplayName = "General Leia"
    PasswordProfile = $PasswordProfile
    UserPrincipalName = "lorgana@TSTrial365.onmicrosoft.com"
    MailNickName = "Leia"
}

#Create User
New-AzureADUser @params

#Confirm Results
Get-AzureADUser
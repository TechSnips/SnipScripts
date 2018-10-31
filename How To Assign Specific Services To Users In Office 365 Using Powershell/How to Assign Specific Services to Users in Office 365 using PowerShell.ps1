<# Pre-requisites
        ** Microsoft Azure AD Module for PowerShell + MSOL Sign-In Assistant
        https://docs.microsoft.com/en-us/office365/enterprise/powershell/connect-to-office-365-powershell

        ** Permissions needed:  Global Admin or User Management Admin
#>

#* Connect to Office 365
$cred = Get-Credential
Connect-MsolService -Credential $cred

#* Retrieve a list of your Licensing Plans
Get-MsolAccountSku

#* Retrieve the Services for a particular Plan (e.g.: ENTERPRISEPACK)
Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -eq "ENTERPRISEPACK" } | ForEach-Object { $_.ServiceStatus }

#* Choose the services to assign to the user(s) - EXAMPLE: assign Exchange Online / SharePoint Online / Teams / SfB / Office Apps (Word, Excel, etc...)
$ServicesToAssign = New-MsolLicenseOptions -AccountSkuId "<YOUR-TENANT-NAME>:ENTERPRISEPACK"`
            -DisabledPlans BPOS_S_TODO_2, FORMS_PLAN_E3, STREAM_O365_E3, Deskless, FLOW_O365_P2, POWERAPPS_O365_P2,`
                                     PROJECTWORKMANAGEMENT, SWAY, YAMMER_ENTERPRISE, RMS_S_ENTERPRISE, SHAREPOINTWAC


#* Assign the services to users - ENTER YOUR OWN LOCATION FOR THE CSV FILE
$myUsers = Import-Csv -Path "C:\Users\$env:USERNAME\Desktop\UsersToLicense.csv"
$O365AcctSku = Get-MsolAccountSku | Where-Object { $_.SkuPartNumber -eq "ENTERPRISEPACK" }

foreach ($user in $myUsers) {
        Set-MsolUser -UserPrincipalName $user.UserPrincipalName -UsageLocation $user.Country
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $O365AcctSku.AccountSkuId -LicenseOptions $ServicesToAssign
}


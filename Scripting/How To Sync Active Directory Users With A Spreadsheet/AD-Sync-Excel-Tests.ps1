# Dell Fairbrass - New User
Get-ADUser -Identity 'dfairbrass0'

# Maible Lingner - Became permanent, should not have an account expiry date
Get-ADUser -Identity 'mlingner2' -Properties 'AccountExpirationDate' |
    Select-Object -Property 'Name', 'AccountExpirationDate'

# Candida Itscowicz - Resigned, should have an account expiry date
Get-ADUser -Identity 'citscowiczd' -Properties 'AccountExpirationDate' |
    Select-Object -Property 'Name', 'AccountExpirationDate'

# Brenton Serrier - Promoted, title should be 'Senior Cost Accountant'
Get-ADUser -Identity 'bserrierf' -Properties 'Title', 'Description' |
    Select-Object -Property 'Name', 'Title', 'Description'

# Pia Giacomuzzi - Reporting line changed, department should be Engineering and 
#                  manager should be Austina Rosenfield
Get-ADUser -Identity 'pgiacomuzzij' -Properties 'Department', 'Manager' |
    Select-Object -Property 'Name', 'DistinguishedName', 'Department', 'Manager' |
    Format-List

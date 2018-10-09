
# Get the webservice account
Get-ADUser -Identity webservice

# Get the account including ServicePrincipalNames property
Get-ADUser -Identity webservice -Properties ServicePrincipalNames

# Adding a SPN to the account
Set-ADUser -Identity webservice -ServicePrincipalNames @{Add='HTTP/webserver'}

# Get the SPNs for account
Get-ADUser -Identity webservice -Properties ServicePrincipalNames | select ServicePrincipalNames

# Add multiple SPNs to account
Set-ADUser -Identity webservice -ServicePrincipalNames @{Add='HTTP/webserveralias','HTTP/WebAlias'}

# Remove a SPN from the account
Set-ADUser -Identity webservice -ServicePrincipalNames @{Remove='HTTP/webserver'}

# Replace all SPN values for an account with new values
Set-ADUser -Identity webservice -ServicePrincipalNames @{Replace='HTTP/Web1','HTTP/Web2','HTTP/Web3'}

# Clear all SPN values for an account
Set-ADUser -Identity webservice -ServicePrincipalNames $null

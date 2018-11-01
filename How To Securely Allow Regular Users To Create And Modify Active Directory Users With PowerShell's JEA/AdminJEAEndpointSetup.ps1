
$server = 'PROD-DC'

# Open a session to server
$session = New-PSSession $server
$session

# Copy the ADUserAdmin module to the Modules folder on the remote server
Copy-Item -Path .\ADUserAdmin -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -ToSession $session -Force

# Copy the Session Configuration File to the C:\ drive on the remote server
Copy-Item -Path .\ADUserAdminEndpoint.pssc -Destination c:\ -ToSession $session -Force

# Return the current PowerShell endpoints on the remote server
Invoke-command -ScriptBlock {Get-PSSessionConfiguration} -ComputerName $server

# Register the new PowerShell endpoint on the remote server using the Session Configuration File
$regScriptblock = {Register-PSSessionConfiguration -Path c:\ADUserAdminEndpoint.pssc -Name 'ADUserAdmin' -Force}

Invoke-Command -Session $session -ScriptBlock $regScriptblock

# Return the updated PowerShell endpoints on the remote server
Invoke-command -ScriptBlock {Get-PSSessionConfiguration} -ComputerName $server

# Save credential for the JEA user
$userName = 'techsnips\jeaadmin'
$credential = Get-Credential -UserName $userName -Message "Enter Password"

# Connect to the new HelpDesk Endpoint
Enter-PSSession -ComputerName $server -ConfigurationName ADUserAdmin -Credential $credential

Get-Command

Get-ADUser -Identity techsnips -Properties City,State

New-User -FirstName 'New' -LastName 'User' -Department 'Accounting'

Get-ADUser -Identity nuser -Properties City,State

Set-ADUser -Identity 'nuser' -City 'Boston' -State 'MA'







# Cleanup
#Invoke-command -ScriptBlock {unregister-PSSessionConfiguration ADUserAdmin} -ComputerName $server
#Invoke-command -ScriptBlock {unregister-PSSessionConfiguration ADUserUpdate} -ComputerName $server
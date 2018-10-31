
$server = 'PROD-DC'

# Open a session to server
$session = New-PSSession $server
$session

# Copy the ADUserUpdate module to the Modules folder on the remote server
Copy-Item -Path .\ADUserUpdate -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -ToSession $session -Force

# Copy the Session Configuration File to the C:\ drive on the remote server
Copy-Item -Path .\ADUserUpdateEndpoint.pssc -Destination c:\ -ToSession $session -Force

# Return the current PowerShell endpoints on the remote server
Invoke-command -ScriptBlock {Get-PSSessionConfiguration} -ComputerName $server

# Register the new PowerShell endpoint on the remote server using the Session Configuration File
$regScriptblock = {Register-PSSessionConfiguration -Path c:\ADUserUpdateEndpoint.pssc -Name 'ADUserUpdate' -Force}

Invoke-Command -Session $session -ScriptBlock $regScriptblock

# Return the updated PowerShell endpoints on the remote server
Invoke-command -ScriptBlock {Get-PSSessionConfiguration} -ComputerName $server

# Save credential for the JEA user
$userName = 'techsnips\jeaupdate'
$credential = Get-Credential -UserName $userName -Message "Enter Password"

# Connect to the new HelpDesk Endpoint
Enter-PSSession -ComputerName $server -ConfigurationName ADUserUpdate -Credential $credential

Get-Command

New-User -FirstName 'Paul' -LastName 'Smith' -Department 'Accounting'

Get-ADUser -Identity nuser -Properties City,State

Set-ADUser -Identity 'nuser' -City 'Providence' -State 'RI'


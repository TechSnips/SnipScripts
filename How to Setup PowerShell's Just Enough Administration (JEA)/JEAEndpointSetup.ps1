
# Open a session to Server1
$session = New-PSSession server1

# Copy the HelpDesk module to the Modules folder on the remote server
Copy-Item -Path .\HelpDesk -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -ToSession $session -Force

# Copy the Session Configuration File to the C:\ drive on the remote server
Copy-Item -Path .\HelpDeskEndpoint.pssc -Destination c:\ -ToSession $session -Force

# Register the new PowerShell endpoint on the remote server using the Session Configuration File
Invoke-Command -Session $session -ScriptBlock {Register-PSSessionConfiguration -Path c:\HelpDeskEndpoint.pssc -Name 'HelpDesk' -Force}

# Connect to the new HelpDesk Endpoint
Enter-PSSession -ComputerName server1 -ConfigurationName HelpDesk





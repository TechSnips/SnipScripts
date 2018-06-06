
Get-ADObject -Filter {Deleted -eq $True -and Name -like $Machine -and ObjectClass -eq "Computer"} -IncludeDeletedObjects | Out-GridView -PassThru | Restore-ADObject

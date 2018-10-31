
Get-ADObject -Filter *

Get-ADObject -Filter {Deleted -eq $True} -IncludeDeletedObjects

Get-ADObject -Filter {Deleted -eq $True} -IncludeDeletedObjects | where {$_.ObjectClass -eq 'user'}

Get-ADObject -Filter {Deleted -eq $True} -IncludeDeletedObjects | where {$_.ObjectClass -eq 'user'} | Out-GridView

Get-ADObject -Filter {Deleted -eq $True} -IncludeDeletedObjects | where {$_.ObjectClass -eq 'user'} | Out-GridView -PassThru | Restore-ADObject
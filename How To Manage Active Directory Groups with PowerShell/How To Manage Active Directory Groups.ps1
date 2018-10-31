#region Creating Groups

New-ADGroup -Name AccountsUsers -GroupScope DomainLocal

#endregion


#region Setting Groups

Get-ADGroup -filter 'Name -eq "AccountsUsers"' -Properties Description

Get-ADGroup -filter 'Name -eq "AccountsUsers"' | Set-ADGroup -Description "All the Accountants"

#endregion


#region Creating Groups from Other Groups

Get-ADGroup -filter 'Name -eq "AccountsUsers"' -Properties Description | New-ADGroup -Name AccountsUsers2 -SamAccountName AccountsUsers2

#endregion


#region Deleting Groups

Remove-ADGroup -Identity AccountsUsers

#endregion 


#region Adding/Removing Members

Add-ADGroupMember -Identity AccountsUsers2 -Members ahowell, abertram, Finance

Get-ADGroupMember -Identity AccountsUsers2 -Recursive | select Name

Remove-ADGroupMember -Identity AccountsUsers2 -Members abertram

#endregion


#region Moving a Group

Get-ADGroup -filter 'Name -eq "AccountsUsers2"' | Move-ADObject -TargetPath "OU=Groups,DC=techsnips,DC=local"

#endregion


#region More

Get-Command -Module ActiveDirectory -Name "*group*"

#endregion



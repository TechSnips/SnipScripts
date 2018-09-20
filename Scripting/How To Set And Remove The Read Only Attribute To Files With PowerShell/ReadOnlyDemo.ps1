#############################################################
#  Available at: https://github.com/TechSnips/SnipScripts   #
#############################################################

$folderName = 'ReadOnlyDemo'

Get-ChildItem -Path C:\$folderName\TestFile.txt

Get-ChildItem -Path C:\$folderName\TestFile.txt | Select *

#region Method 1

$source = Get-ChildItem -Path C:\$folderName\TestFile.txt

Set-ItemProperty -Path $source -Name IsReadOnly -Value $true

Get-ChildItem -Path C:\$folderName\TestFile.txt | Select *

#endregion


#region Method 2

$source = Get-ChildItem -Path C:\$folderName\TestFile.txt

$source.IsReadOnly

$source.IsReadOnly = $false

Get-ChildItem -Path C:\$folderName\TestFile.txt | Select *

#endregion


#region Recursive

Get-ChildItem -Path C:\$folderName\ -Recurse | Where IsReadOnly -EQ $true

$source = Get-ChildItem -Path C:\$folderName\ -Recurse | Where IsReadOnly -EQ $true

Set-ItemProperty -Path $source.fullName -Name IsReadOnly -Value $false

$source | Set-ItemProperty -Name IsReadOnly -Value $false

Get-ChildItem -Path C:\$folderName\ -Recurse | Where IsReadOnly -EQ $true

#endregion
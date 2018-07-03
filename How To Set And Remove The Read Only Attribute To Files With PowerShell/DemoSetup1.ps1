#############################################################
#  Available at: https://github.com/TechSnips/SnipScripts   #
#############################################################

$folderName = 'ReadOnlyDemo'

cd c:\

Remove-Item C:\$folderName\ -Force -Recurse

New-Item -Path c:\$folderName -ItemType Directory -Force
New-Item -Path c:\$folderName\TestFile.txt -ItemType File -Force

explorer C:\$folderName\

$i = 0

While ($i -le 9) {
    New-Item -Path "C:\$folderName\Folder-$i" -ItemType Directory -Force
    $j = 0

    while ($j -le 9) {
        New-Item -Path "C:\$folderName\Folder-$i\File-$j.txt" -Force
        $j++
    }
    $i++
}


Set-ItemProperty -Path C:\$folderName\Folder-0\File-3.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-0\File-7.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-0\File-9.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-1\File-1.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-1\File-3.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-1\File-4.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-1\File-5.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-2\File-2.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-2\File-3.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-2\File-4.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-3\File-3.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-3\File-5.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-7\File-1.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-7\File-5.txt -Name IsReadOnly -Value $true
Set-ItemProperty -Path C:\$folderName\Folder-7\File-7.txt -Name IsReadOnly -Value $true

cd C:\$folderName

Get-ChildItem C:\$folderName -Recurse | where IsReadOnly -eq $true | select FullName


#region ProGet Repository

Get-PSRepository

Get-PSRepository | Select *

$repo = @{
    Name               = 'PSRepo'
    SourceLocation     = 'http://proget/nuget/PSRepo/'
    PublishLocation    = 'http://proget/nuget/PSRepo/api/v2/package'
    InstallationPolicy = 'Trusted'
}

Register-PSRepository @repo

Get-PSRepository

Find-Module -Repository PSRepo

#endregion

#region FileShare Repository

$repo2 = @{
    Name =               'FileShareRepo'
    SourceLocation =     '\\server1\FileShareRepo'
    PublishLocation =    '\\server1\FileShareRepo'
    InstallationPolicy = 'Trusted'
}

Register-PSRepository @repo2

Get-PSRepository

Find-Module -Repository FileShareRepo

#endregion

#region Setting PowerShell Repositories

cls

Get-PSRepository

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Get-PSRepository

#endregion

#region PSGallery

Get-PSRepository -Name PSGallery | Unregister-PSRepository

Get-PSRepository

Register-PSRepository -Default

Get-PSRepository

#endregion
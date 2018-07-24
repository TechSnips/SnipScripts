######################################################################
# Prerequisites:                                                     #
#                                                                    #
# 1. Visual Studio                                                   #
# 2. A server running IIS                                            #
#                                                                    #
# This script available at: https://github.com/TechSnips/SnipScripts #
######################################################################

#region Configure Web Server

$webServer = 'Web01'

$scriptBlockWeb = {
    $windowsFeatures = 'Web-Server', 'Web-WebServer', 'Web-Common-Http', 'Web-Default-Doc', 'Web-Dir-Browsing', 'Web-Http-Errors', 'Web-Static-Content',
                       'Web-Health', 'Web-Http-Logging', 'Web-Performance', 'Web-Stat-Compression', 'Web-Security', 'Web-Filtering', 'Web-App-Dev',
                       'Web-Net-Ext45', 'Web-Asp-Net45', 'Web-ISAPI-Ext', 'Web-ISAPI-Filter', 'Web-Mgmt-Tools', 'Web-Mgmt-Console'
    
    Install-WindowsFeature $windowsFeatures -Verbose

    # Create and share web content folder
    New-Item -Path c:\inetpub\wwwroot\Feeds -ItemType Directory -Force
    New-SmbShare -Name Feeds -Path c:\inetpub\wwwroot\Feeds -ChangeAccess 'corp\matt'
}

Invoke-Command -ComputerName $webServer -ScriptBlock $scriptBlockWeb

#endregion

#region Register NuGet feed with PowerShell

Get-PSRepository

$params = @{
    Name               = 'NuGetFeed';
    SourceLocation     = 'http://web01/Feeds/nuget';
    PublishLocation    = 'http://web01/Feeds/nuget';
    InstallationPolicy = 'Trusted'

}

Register-PSRepository @params

# Find available modules from the new feed.
Find-Module -Repository NuGetFeed

#endregion

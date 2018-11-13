$server = ''

# Get the Current LCM settings for $server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager)}

[DscLocalConfigurationManager()]
Configuration DSCConfig {
    Param([string]$NodeName = ‘localhost’)

    Node $NodeName {

        #region LCM Settings
        Settings {
            RefreshFrequencyMins = 30;
            RefreshMode = “PULL”;
            ConfigurationMode = “ApplyAndMonitor”;
        }
        #endregion

        #region Configuration
        ConfigurationRepositoryWeb PullServer {
            ServerURL = “http://server2019:8080/PSDSCPullServer.svc/”
            RegistrationKey = “cb30127b-4b66-4f83-b207-c4801fb05087”
            ConfigurationNames = @(“WebServer”)
            AllowUnsecureConnection = $true
        }
        #endregion

        #region Report server setup. Does not need to be the same Pull server as the ConfigurationRepositoryWeb
        ReportServerWeb ReportServer {
            ServerURL = “http://server2019:8080/PSDSCPullServer.svc/”
            RegistrationKey = “cb30127b-4b66-4f83-b207-c4801fb05087”
            AllowUnsecureConnection = $true
        }
        #endregion  
    }
}

DSCConfig -OutputPath C:\Config -Verbose -NodeName $server

Set-DscLocalConfigurationManager -Path C:\Config -Verbose

Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager)}

Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager).ReportManagers}
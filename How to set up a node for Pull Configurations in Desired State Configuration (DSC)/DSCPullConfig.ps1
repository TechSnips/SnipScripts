################################################################
################################################################
##                                                            ##
## Configuring the Local Configuration Manager:               ##
## https://docs.microsoft.com/en-us/powershell/dsc/metaconfig ##
##                                                            ##
################################################################
################################################################


[DSCLocalConfigurationManager()]
configuration LCMPullConfig
{
    Node server1
    {
        
        Settings {
            RefreshMode = 'Pull'
            ConfigurationMode = 'ApplyAndAutoCorrect'
            ConfigurationModeFrequencyMins = 30
            RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryWeb PullServer {
            ServerURL = 'https://DSCPULL/PSDSCPullServer.svc'
            RegistrationKey = 'cccf8653-84a6-4a36-b95e-6916c31bee72'
            ConfigurationNames = @('WebConfig')
        }

        ReportServerWeb PullServer {
            ServerURL = 'https://DSCPULL/PSDSCPullServer.svc'
        }
    }
}

LCMPullConfig -OutputPath LCMConfig

Set-DscLocalConfigurationManager -Path .\LCMConfig
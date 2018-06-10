Configuration SampleConfiguration
{     

    Import-DscResource -ModuleName WebServerConfig

    Node Server1 {
        
        WebFeatures InstallFeatures {

        }
 
        File LOG_Directory {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Logs"
        }
                
        Registry SomeRegKeyChange
        {
            Ensure = "Present" 
            Key =  "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SomeRegKey"
            ValueName = "RegValueName"
            ValueType = "ExpandString"
            ValueData = "RegValue"
        }  
    }
}

SampleConfiguration -OutputPath .\MOF

ise .\MOF\Server1.mof
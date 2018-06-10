Configuration SampleConfiguration
{     
    Node Server1 {

        WindowsFeature WebServer {
             Name = "Web-Server"
             Ensure = "Present"
         }

         WindowsFeature WebWindowsAuth {
             Name = "Web-Windows-Auth"
             Ensure = "Present"
         }

         WindowsFeature WebMgmtConsole {
            Name = "Web-Mgmt-Console"
            Ensure = "Present"
        }

         WindowsFeature Web-App-Dev {
            Name = "Web-App-Dev"
            Ensure = "Present"
        }

        WindowsFeature Web-Security {
            Name = "Web-Security"
            Ensure = "Present"
        }

        WindowsFeature Web-Stat-Compression {
            Name = "Web-Stat-Compression"
            Ensure = "Present"
        }
 
        File LOG_Directory {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Logs"
        }
                
        Registry SomeRegKeyChange {
            Ensure = "Present" 
            Key =  "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SomeRegKey"
            ValueName = "RegValueName"
            ValueType = "ExpandString"
            ValueData = "RegValue"
        }  
    }
}
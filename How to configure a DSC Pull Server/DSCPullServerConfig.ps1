

configuration DscPullServer {  
    param (  
        [string[]]$NodeName = 'localhost',  
        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] 
        [string] $RegistrationKey  
    )  
    
    # Download from the PowerShell Gallery: Install-Module xPSDesiredStateConfiguration
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration  
 
    Node $NodeName {  
        WindowsFeature DSCServiceFeature {  
            Ensure = 'Present' 
            Name = 'DSC-Service'  
        }  
 
        xDscWebService PSDSCPullServer {  
            Ensure = 'Present'  
            EndpointName = 'PSDSCPullServer'  
            Port = 80 
            PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"  
            ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"  
            ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"  
            State = 'Started' 
            DependsOn = '[WindowsFeature]DSCServiceFeature'  
            CertificateThumbPrint = "AllowUnencryptedTraffic" 
            UseSecurityBestPractices = $false
        }  
 
        File RegistrationKeyFile { 
            Ensure = 'Present' 
            Type = 'File' 
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt" 
            Contents = $RegistrationKey 
            DependsOn = '[WindowsFeature]DSCServiceFeature' 
        } 
 
        WindowsFeature WebMgmtTools {  
            Ensure = 'Present' 
            Name = 'Web-Mgmt-Tools'  
        }  
    } 
} 
　 


# Run the DscPullServer configuration to create the MOF
DSCPullServer -RegistrationKey 'de604a71-cd51-4e87-b989-cb06bee6f973' -OutputPath c:\Configs\PullServer80


# Run the compiled configuration to make the target node a DSC Pull Server 
Start-DscConfiguration -Path c:\Configs\PullServer -Wait -Verbose 
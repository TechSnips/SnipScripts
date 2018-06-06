

configuration DscPullServer {  
    param (  
        [string[]]$NodeName = 'localhost',  
        [ValidateNotNullOrEmpty()]  
        [string] $certificateThumbPrint, 
        [Parameter(Mandatory)] 
        [ValidateNotNullOrEmpty()] 
        [string] $RegistrationKey  
    )  
    
    # Download from the PowerShell Gallery: Install-Module xPSDesiredStateConfiguration　 
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 8.2.0.0
 
    Node $NodeName {  
       
        WindowsFeature DSCServiceFeature {  
            Ensure = 'Present' 
            Name = 'DSC-Service'  
        }  
 
        xDscWebService PSDSCPullServer {  
            Ensure = 'Present'  
            EndpointName = 'PSDSCPullServer'  
            Port = 443 
            PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"  
            ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"  
            ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"  
            State = 'Started' 
            DependsOn = '[WindowsFeature]DSCServiceFeature'  
            CertificateThumbPrint = $certificateThumbPrint 
            UseSecurityBestPractices = $true
        }  
 
        File RegistrationKeyFile { 
            Ensure = 'Present' 
            Type = 'File' 
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt" 
            Contents = $RegistrationKey 
            DependsOn = '[WindowsFeature]DSCServiceFeature' 
        } 
        
        # (Optional)
        WindowsFeature WebMgmtTools {  
            Ensure = 'Present' 
            Name = 'Web-Mgmt-Tools'  
        }  
    } 
} 
　 

# Find the Thumbprint for an installed SSL certificate for use with the pull server 

$cert = Get-ChildItem Cert:\LocalMachine\my | Where-Object FriendlyName -eq 'dscpull'
$cert

# Generate a new registration key to pass to the configuration 

$regKey = New-Guid
$regKey

# Then include the thumbprint and registration key when running the configuration to create a MOF

DSCPullServer -certificateThumbprint $cert.Thumbprint -RegistrationKey $regKey -OutputPath c:\Configs\PullServer

# Run the compiled configuration to make the target node a DSC Pull Server 
Start-DscConfiguration -Path c:\Configs\PullServer -Wait -Verbose 
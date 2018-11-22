
configuration PullServerSQL {
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 8.4.0.0

    WindowsFeature dscservice {
        Name   = 'Dsc-Service'
        Ensure = 'Present'
    }

    File PullServerFiles {
        DestinationPath = 'c:\pullserver'
        Ensure = 'Present'
        Type = 'Directory'
        Force = $true
    }

    xDscWebService PSDSCPullServer {
        Ensure                  = 'Present'
        EndpointName            = 'PSDSCPullServer'
        Port                    = 443
        PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer"
        CertificateThumbPrint   = '3780CAB9520A75188E5E88F1CECB840B374F6A01'
        ModulePath              = "c:\pullserver\Modules"
        ConfigurationPath       = "c:\pullserver\Configuration"
        State                   = 'Started'
        RegistrationKeyPath     = "c:\pullserver"
        UseSecurityBestPractices= $true
        SqlProvider             = $true
        SqlConnectionString     = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=server2019;Database=DSC'
        # SqlConnectionString   = 'Provider=SQLOLEDB.1;Server=<SQl Server>;Database=DSC;User ID=SA;Password=<SQL Password>;Initial Catalog=master;'
        DependsOn               = '[File]PullServerFiles', '[WindowsFeature]dscservice'
    }

    File RegistrationKeyFile {
        Ensure          = 'Present'
        Type            = 'File'
        DestinationPath = "c:\pullserver\RegistrationKeys.txt"
        Contents        = 'cb30127b-4b66-4f83-b207-c4801fb05087'
        DependsOn       = '[File]PullServerFiles'
    }
}

PullServerSQL

Start-DscConfiguration -Path .\PullServerSQL -Wait -Verbose -Force


Invoke-WebRequest -Uri 'https://server2019/PSDSCPullServer.svc' -UseBasicParsing
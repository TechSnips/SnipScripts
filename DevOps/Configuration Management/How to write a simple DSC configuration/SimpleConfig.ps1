Configuration StandardWebServer {

    Node Server1 {

        WindowsFeature WebServer {
            Name = 'web-server'
            Ensure = 'Present'
        }

        File HelloWorld {
            DestinationPath = 'c:\inetpub\wwwroot\HelloWorld.html'
            Contents = 'Hello World!!'
            Type = 'File'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]WebServer'
        }


    } #Node


} # Configuration


StandardWebServer -OutputPath C:\Configs

Start-DscConfiguration C:\Configs -Wait -Verbose
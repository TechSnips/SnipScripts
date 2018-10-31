
# Specifies that the latest microsoft/iis image will be used as the base image
FROM microsoft/iis:latest

# Sets the default shell when running commands to PowerShell. Default is CMD
SHELL ["powershell"]

# Copies contents of the wwwroot folder to the inetpub/wwwroot folder in the new container image
COPY wwwroot c:/inetpub/wwwroot

# Run some PowerShell commands within the new container to set up the image
RUN Remove-Item c:/inetpub/wwwroot/iisstart.htm -force; \
    Remove-Item c:/inetpub/wwwroot/iisstart.png -force; \
    Import-Module WebAdministration; \
    New-WebAppPool -Name 'TestPool'

# Exposes port 80 on the new container image
#EXPOSE 80

# Sets the main command of the container image
#ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]

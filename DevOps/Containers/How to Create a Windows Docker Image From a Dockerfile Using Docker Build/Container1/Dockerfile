
# Specifies that the latest microsoft/iis image will be used as the base image
FROM microsoft/iis:latest

# Copies contents of the wwwroot folder to the inetpub/wwwroot folder in the new container image
COPY wwwroot c:/inetpub/wwwroot

# Run some PowerShell commands within the new container to set up the image
RUN powershell Remove-Item c:/inetpub/wwwroot/iisstart.htm -force
RUN powershell Remove-Item c:/inetpub/wwwroot/iisstart.png -force
RUN powershell Import-Module WebAdministration
RUN powershell New-WebAppPool -Name 'TestPool'

# Exposes port 80 on the new container image
#EXPOSE 80

# Sets the main command of the container image
#ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]


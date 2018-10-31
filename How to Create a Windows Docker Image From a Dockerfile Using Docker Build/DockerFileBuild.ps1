Set-Location C:\Containers\

Get-ChildItem

docker images

Invoke-Item .\Container1

code .\Container1\Dockerfile

docker build -t container1 .\Container1

Clear-Host
docker images

$containerID = docker run -d container1
$containerID

Clear-Host
docker ps

docker exec $containerID powershell Get-ChildItem c:\inetpub\wwwroot

docker exec $containerID ipconfig

#################################################

Clear-Host
Set-Location C:\Containers\

Get-ChildItem .\Container2

docker history container1

code .\Container2\Dockerfile

docker build -t container2:V2 .\Container2

Clear-Host
docker images

$containerID = docker run -d container2:V2
$containerID

docker ps

docker exec $containerID ipconfig

docker history container1

docker history container2:V2

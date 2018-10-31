# PreReqs
Azure Subscription
Packer
https://www.packer.io/downloads.html
TechSnipGitHub for code used in this snip
https://github.com/TechSnips/SnipScripts

Push-Location E:\packer

# Retrieve the Service Principal
$sp = Get-AzureRmADServicePrincipal -DisplayNameBeginsWith AzurePacker

# Gather details for the 'packer' configuration
$sp.applicationId.guid | clip   #client_id
$sp.id.guid | clip              #object_id

$sub = Get-AzureRmSubscription
$sub.TenantId | clip            #tenant_id
$sub.SubscriptionId | clip      #subscription_id

# Resource group
Get-AzureRmResourceGroup

# Create Packer Image
.\packer.exe build windows.json 

Clear-Host

# Create a VM from the image
New-AzureRmVm `
    -ResourceGroupName SNIPResGrp `
    -Name "SERVER1" `
    -Location uksouth `
    -VirtualNetworkName "SNIPVnet" `
    -SubnetName "SNIPSubnet" `
    -SecurityGroupName "SNIPNetworkSecurityGroup" `
    -PublicIpAddressName "SNIPPublicIpAddress" `
    -OpenPorts 80 `
    -Image "SNIPPackerImage" `
    -Size "Standard_B1ms"     
    
     # techsnipadmin
     # P@ss123456uiop$

# Test VM and Web Server
$ipaddress = Get-AzureRmPublicIPAddress `
    -ResourceGroupName SNIPResGrp `
    -Name "SNIPPublicIPAddress" | select "IpAddress"

Start-Process "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" `
    -ArgumentList $ipaddress.IpAddress.ToString()
Get-AzLocation | Select Location,DisplayName
$locName = "centralus"

Get-AzVMImagePublisher -Location $locName | where-object {$_.PublisherName -like "*windows*"} | ft PublisherName,Location
$pubName="MicrosoftWindowsServer"

Get-AzVMImageOffer -Location $locName -PublisherName $pubName | ft Offer,PublisherName,Location
$offerName="WindowsServer"

Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | ft Skus,Offer,PublisherName,Location
$skuName="2016-Datacenter"

Get-AzVMImage -Location $locName -PublisherName $pubName -Skus $skuName -Offer $offerName
$version = "2016.127.20180613"


#Fortinet Example

Get-AzLocation | Select Location,DisplayName
$locName = "centralus"

Get-AzVMImagePublisher -Location $locName | where-object {$_.PublisherName -like "*forti*"} | ft PublisherName,Location
$pubName="fortinet"

Get-AzVMImageOffer -Location $locName -PublisherName $pubName | ft Offer,PublisherName,Location
$offerName="fortinet_fortigate-vm_v5"

Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | ft Skus,Offer,PublisherName,Location
$skuName="fortinet_fg-vm"

Get-AzVMImage -Location $locName -PublisherName $pubName -Skus $skuName -Offer $offerName
$version = "5.6.4"

Write-Output "`"imageReference`": { `r
`t`"publisher`": `"$pubName`" `r
`t`"offer`": `"$offerName`" `r
`t`"sku`": `"$skuName`" `r
`t`"version`": `"$version`" `r
}"

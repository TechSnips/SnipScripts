#region Prep
Install-Module AzureRm
Connect-AzureRmAccount

Get-AzureRmStorageAccount -ResourceGroupName 'SharedLab'
#endregion

#region Variables
$ResourceGroup  = 'SharedLab'
$StorageAccount = 'techsnipsimages'
$Container      = 'vhd-sorage'
$AzureLocation  = 'East US'

$ImageName      = 'WinServer2019-Base'

$UploadUrl      = "https://$StorageAccount.blob.core.windows.net/$Container/$ImageName.vhd"
$LocalPath      = 'D:\VM-Images\Server.2019-base.vhd'
#endregion

#region Upload VHD
$Splat = @{
    ResourceGroupName       = $ResourceGroup
    Destination             = $UploadUrl
    LocalFilePath           = $LocalPath
    NumberOfUploaderThreads = 64
}
Add-AzureRmVhd @Splat
#endregion

#region Create an image
$Image = New-AzureRmImageConfig -Location $AzureLocation

$Splat = @{
    Image      = $Image
    OsType     = 'Windows'
    OsState    = 'Generalized'
    BlobUri    = $UploadUrl
    DiskSizeGB = 75
}
$Image = Set-AzureRmImageOsDisk @Splat

$Splat = @{
    ImageName         = $ImageName
    ResourceGroupName = $ResourceGroup
    Image             = $Image
}
New-AzureRmImage @Splat
#endregion

#region Spin up a new VM
$Splat = @{
    Name               = 'VMfromVHD'
    ImageName          = $ImageName
    ResourceGroupName  = $ResourceGroup
    Location           = $AzureLocation
    VirtualNetworkName = 'General-vnet'
    SubnetName         = 'default'
}
New-AzureRmVM @Splat

Get-AzureRmVM -Name 'VMfromVHD' -ResourceGroupName $ResourceGroup
#endregion
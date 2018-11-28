function Resize-AzureRMVM ($VM, $VMNewSize) {

    $VirtualMachine = Get-AzureRmVM | Where-Object {$_.name -eq $VM}

    $VirtualMachine.HardwareProfile.VmSize = $VMNewSize 

    $VirtualMachine | Update-AzureRmVM -AsJob
}
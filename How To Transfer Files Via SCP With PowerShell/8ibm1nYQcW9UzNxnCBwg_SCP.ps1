install-module posh-ssh
$credential = Get-Credential

#To upload folder contents to server
Set-SCPFolder -ComputerName '172.17.194.172' -Credential $credential -LocalFolder 'C:\scp' -RemoteFolder '/home/jbc/scp'
Get-SCPFolder -ComputerName '172.17.194.172' -Credential $credential -LocalFolder 'C:\scp' -RemoteFolder '/home/jbc/scp'

#Set File
Set-SCPFile -ComputerName '172.17.194.172' -Credential $credential -RemotePath '/home/jbc/scp/' -LocalFile 'C:\scp\TextDoc.txt'
Get-SCPFile -ComputerName '172.17.194.172' -Credential $credential -RemoteFile '/home/jbc/scp/TextDoc.txt' -LocalFile 'C:\scp\TextDoc.txt'

Get-Content -Path 'C:\scp\TextDoc.txt' | Out-File -Encoding utf8 -Path 'C:\scp\TextDoc.txt'
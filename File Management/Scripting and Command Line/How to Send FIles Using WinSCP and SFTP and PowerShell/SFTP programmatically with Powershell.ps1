#How To Send Files Using Winscp\ Sftp Programmatically With PowerShell

#region
# Load the Assembly and setup the session properties
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll" 
 
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "10.200.0.10"
        UserName = "sshuser" 
        Password = "Password1" 
        SshPrivateKeyPath = "E:\scripts\sshuser-private.ppk"
        SshPrivateKeyPassphrase = "Password1"
        SshHostKeyFingerprint = "ssh-rsa 3072 9e:c1:c1:23:ed:b4:7d:29:3f:0b:eb:a7:4e:bb:0b:f9"
    }
 
$session = New-Object WinSCP.Session
#endregion

#region
# Gather files last written to over 5 seconds ago
$filelist = Get-ChildItem e:\data | where {$_.LastWriteTime -lt (Get-Date).AddSeconds(-20)}
#endregion

#region
# Connect And send files, then close session
    try
    {
        # Connect
        $session.DebugLogPath = "E:\data\sftp.log"
        $session.Open($sessionOptions)
                
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        foreach ($file in $filelist)
        {
            $transferResult = $session.PutFiles("e:\data\$file", "/", $False, $transferOptions)
                foreach ($transfer in $transferResult.Transfers)
                    {
                        Write-Host "Upload of $($transfer.FileName) succeeded"
                    }
        }
   
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
#endregion

#region
# Catch any errors
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
#endregion
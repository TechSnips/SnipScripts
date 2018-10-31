#Local Computer /w Rename
Add-Computer -NewName 'workstation3' -DomainName 'techsnips-test.local' -Restart

#Remote Computers
$Computers = 'workstation1', 'workstation2'

$Domain = 'techsnips-test.local'
$OU = 'OU=computers,OU=techsnips,DC=techsnips-test,DC=local'

$LocalCred = Get-Credential -Message 'Local Credentials'
$DomainCred = Get-Credential -Message 'Domain Credentials'

$Params = @{
    ComputerName    = $Computers
    DomainName      = $Domain
    OUPath          = $OU
    LocalCredential = $LocalCred
    Credential      = $DomainCred
    Restart         = $true
}

Add-Computer @Params

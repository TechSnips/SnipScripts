#region decisions
# Set WDS client requirements
$AnswerClients = 'all' # {All | Known | *None*}]
$adminApproval = 'Disabled' # {AdminApproval | *Disabled*}

# Path to boot program on WDS Server, common options are:
    # UEFI: boot\x64\wdsmgfw.efi
    # Legacey 64bit: boot\x64\wdsnbp.com
    # Legacey 32bit: boot\x86\wdsnbp.com
$bootProgramPath = 'boot\x64\wdsmgfw.efi' 
#endregion decisions

#region wds settings
wdsutil /Set-Server /AnswerClients:$AnswerClients  
wdsutil /set-server /AutoaddPolicy /Policy:$adminApproval

wdsutil /Get-Server /Show:Config | Select-String "Answer Clients"
wdsutil /Get-Server /Show:Config | Select-String "Pending Device Policy:" -context 0,2 
#endregion

# Set Boot Server DHCP Setting
#region dhcp Settings
$dhcpOptionArgs = @{ 
    ComputerName = "dhcp" # DHCP server name
    ScopeId = "192.168.0.0" # Coorisponds to IP address range that will recieve the PXE info 
    optionID = 066 # TFTP Server Name Option
    value = "192.168.0.12" # WDS Server's fqdn or IP address
} 
Set-DhcpServerv4OptionValue @dhcpOptionArgs

# Set boot filepath DHCP Setting
$dhcpOptionArgs.optionID = 067 # Filename Option
$dhcpOptionArgs.value = $bootProgramPath  
Set-DhcpServerv4OptionValue @dhcpOptionArgs

# review DHCP settings
$dhcpOptionArgs = @{ 
    ComputerName = $dhcpOptionArgs.ComputerName # DHCP server name
    ScopeId = $dhcpOptionArgs.ScopeId # Coorisponds to IP address range that will recieve the PXE info 
} 
Get-DhcpServerv4OptionValue @dhcpOptionArgs | select optionID, name, value

#endregion

# Test with UEFI client with PXE support

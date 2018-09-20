
#region Read-Host
$UserName = Read-Host -Prompt 'What is your username?'
$UserName
$SecureString = Read-Host -Prompt 'Provide your password:' -AsSecureString
$SecureString
#endregion

#region Mandatory parameters
function Reboot-Server {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName
    )
    Write-Host "Rebooting $ComputerName"
}
Reboot-Server
#endregion

#region Host.ChoiceDescription .Net Method
$Services = [System.Management.Automation.Host.ChoiceDescription]::new('&Services')
$Services.HelpMessage = 'Get running services'
$Processes = New-Object System.Management.Automation.Host.ChoiceDescription '&Processes', 'Get running processes'
$Quit = New-Object System.Management.Automation.Host.ChoiceDescription '&Quit', 'Quit menu'
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Services, $Processes, $Quit)
$Result = $host.ui.PromptForChoice('Task Menu', 'Select a task', $options, 0)
$Result
#endregion

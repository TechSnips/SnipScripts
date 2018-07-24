<#
    In this demo we will demonstrate how to create Starter Group Policy Objects.

    I am using the following technology:
        ->Windows Server 2016 Standard
            ->Roles
            ->ADDNS
        ->Features
            ->Group Policy Management
        ->PowerShell 5.1
        ->Visual Studio Code June 2018 Update
        ->Add-ons
            ->PowerShell - https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
            ->Code Runner - https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner
#>
# We need to ensure we have the GroupPolicy module available. It *should be* installed already if you have GPMC installed.
Import-Module -Name GroupPolicy

# Lets discover what cmdlets are available now to create policy objects, and limit our scope of results.
Get-Command -Module GroupPolicy -Name 'New-*'

# Found a cmdlet that may work, lets check out the example help for now.
Get-Help New-GPStarterGPO -Examples

# Excellent, now that we have some examples, we will create a new starter group policy object.
New-GPStarterGPO -Name 'Standard Desktop Policy' -Comment 'This policy contains all corporate baseline standards.'

<# 
    Note in the above example we did not specify a domain controller or domain. This demo is taking place on the domain controller
    to keep things as simple as possible. Further discussion starts to get out of the scope of this demo.
#>

<# 
    We can verify that our new object is present before proceeding to use the Group Policy Management Console (GPMC).
#>
Get-GPStarterGPO -Name 'Standard Desktop Policy'

# That's it! You can now use GPMC from any of your management systems to adjust the policy to your needs.
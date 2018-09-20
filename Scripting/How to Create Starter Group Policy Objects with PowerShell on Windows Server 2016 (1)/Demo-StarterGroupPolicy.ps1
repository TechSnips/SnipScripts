<#
    I am using the following technology:
        ->Windows Server 2016 Standard
            ->Roles
            ->ADDNS
        ->Features
            ->Group Policy Management
#>

# Lets create a new starter group policy object.
New-GPStarterGPO -Name 'Standard Desktop Policy' -Comment 'This policy contains all corporate baseline standards.'

# This time we will include the domain controller parameter and create another starter group policy object.
New-GPStarterGPO -Name 'Standard Server Policy' -Comment 'This policy contains all corporate baseline standards.' -Server '[YOUR DC HERE]'

# We can verify that our new objects are present before proceeding to use the Group Policy Management Console (GPMC).
Get-GPStarterGPO -Name * # using a wild card here so we see all the starter GPO's

# That's it! You can now use GPMC from any of your management systems to adjust the policies to your needs.
# Basics: Viewing and Creating OUs
Get-ADOrganizationalUnit -Filter *
New-ADOrganizationalUnit -Name 'techsnips'



# Creating new OUs under an existing OU
Get-ADOrganizationalUnit -Filter {Name -eq 'techsnips'}

$BaseOU = (Get-ADOrganizationalUnit -Filter {Name -eq 'techsnips'}).DistinguishedName
New-ADOrganizationalUnit -Name 'computers' -Path $BaseOU
New-ADOrganizationalUnit -Name 'users' -Path $BaseOU



# Using an existing OU as a template for new OUs
$Template = @{
    Name     = 'New York City'
    State    = 'NY'
    Country  = 'US'
    Path     = "OU=users,$BaseOU"
}
New-ADOrganizationalUnit @Template

$Template.Name  = 'Los Angeles'
$Template.State = 'CA'
New-ADOrganizationalUnit @Template

$Template.Name  = 'Chicago'
$Template.State = 'IL'
New-ADOrganizationalUnit @Template

$Template.Name  = 'Houston'
$Template.State = 'TX'
New-ADOrganizationalUnit @Template

$Template.Name  = 'Seattle'
$Template.State = 'WA'
New-ADOrganizationalUnit @Template



# Setting and viewing properties of OUs
Set-ADOrganizationalUnit -Identity $BaseOU -Description 'Root OU for the TechSnips organization'
Get-ADOrganizationalUnit -Filter {Name -eq 'techsnips'}
Get-ADOrganizationalUnit -Filter {Name -eq 'techsnips'} -Properties Description



# Deleting OUs, and protecting OUs from deletion
Remove-ADOrganizationalUnit -Identity "OU=Chicago,OU=users,$BaseOU"

Set-ADOrganizationalUnit -Identity "OU=Chicago,OU=users,$BaseOU" -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit -Identity "OU=Chicago,OU=users,$BaseOU" -Confirm:$false

Get-ADOrganizationalUnit -Filter * -SearchBase "OU=users,$BaseOU" -SearchScope Subtree


New-ADOrganizationalUnit -Name 'TestOU' -ProtectedFromAccidentalDeletion $false
Get-ADOrganizationalUnit -Filter {Name -eq 'TestOU'} | Remove-ADOrganizationalUnit



# Moving OUs
New-ADOrganizationalUnit -Name 'Chicago'

$ChicagoOU = (Get-ADOrganizationalUnit -Filter {Name -eq 'Chicago'}).DistinguishedName

Set-ADOrganizationalUnit -Identity $ChicagoOU -ProtectedFromAccidentalDeletion $false

Move-ADObject -Identity $ChicagoOU -TargetPath "OU=users,$BaseOU"

Get-ADOrganizationalUnit -Filter {Name -eq 'Chicago'} | 
    Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true
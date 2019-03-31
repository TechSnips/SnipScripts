<#
.SYNOPSIS
	Remove a user from Office 365 groups

.DESCRIPTION
    The named user is removed from all Office 365 groups, both as member and owner.
    A named newowner is made owner in order to prevent orphaned groups.

.INPUTS
      $upn          # User being removed
      $newowner     # User taking group ownership

.OUTPUTS
  	None

.NOTES
	Version:        1.0
	Author:         Ryan Van Cleave
	Creation Date:  03.24.2019

.EXAMPLE
  	None provided
#>
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Connect to Azure AD
Connect-AzureAD

#---------------------------------------------------------[Declarations]--------------------------------------------------------
# Arrays for capturing the actions
$ownerof    = @()
$memberof   = @()

#---------------------------------------------------------[Execution]--------------------------------------------------------
# Get all of the Office 365 groups
$O365Groups = Get-AzureADMSGroup -All:$true -Filter "groupTypes/any(c:c eq 'Unified')"
Write-Output "$($O365Groups.Count) Office 365 groups were found"

# Get info for departing user
$upn        = Read-Host "UserPrincipalName of user being removed from groups"
$AADUser     = Get-AzureADUser -SearchString $upn

# Get info for newowner
$newowner   = Read-Host "UserPrincipalName of user taking over group ownership"
$AADsubstitution = Get-AzureADUser -SearchString $newowner

# Check each group for the user
foreach ($group in $O365Groups) {
    $members = (Get-AzureADGroupMember -ObjectId $group.id).UserPrincipalName

    # Check if they are a member
    If ($members -contains $AADUser.UserPrincipalName) {
        Remove-AzureADGroupMember -ObjectId $group.Id -MemberId $AADUser.ObjectId 
        Write-Output "Removed from $($group.DisplayName)"

        # Add the group to the memberof list
        $memberof += $group

        # Check if they are an owner
        $owners  = Get-AzureADGroupOwner -ObjectId $group.id
        foreach ($owner in $owners) {
            If ($AADUser.UserPrincipalName -eq $owner.UserPrincipalName) {
  
                # If needed, add new owner to prevent orphaned group
                If ($owners.count -lt 2){
                    Write-Host "$($AADsubstitution.UserPrincipalName) was added as a new owner" -ForegroundColor Green
                    Add-AzureADGroupOwner -ObjectId $group.Id -RefObjectId $AADsubstitution.ObjectId
                } 

                # Remove the user as owner
                Write-Host "Removed as ownerof $($group.DisplayName)" -ForegroundColor Red
                Remove-AzureADGroupOwner -ObjectId $group.Id -OwnerId $AADUser.ObjectId

                # Add the group to the ownerof list
                $ownerof += $group
            }
        }
    }
}

# Groups that the user owned:
Write-Output "Owner of:"
$ownerof | Select-Object DisplayName

#Groups that the user was a member of:
Write-Output "Member of:"
$memberof | Select-Object DisplayName

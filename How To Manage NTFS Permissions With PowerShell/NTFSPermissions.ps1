#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
If(Test-Path $dir){
    Remove-Item $dir -Recurse -Force -Confirm:$false
}
New-Item $dir -ItemType Directory
New-Item "$dir\dog.txt" -ItemType File
New-Item "$dir\cat.txt" -ItemType File
#add fido to dog.txt
$identity = 'techsnipsdemo\Fido'
$rights = 'FullControl'
$type = 'Allow'
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$type)
$ACL = Get-Acl "$dir\dog.txt"
$ACL.AddAccessRule($ACE)
Set-Acl "$dir\dog.txt" -AclObject $ACL
Function Prompt(){}
Clear-Host
#endregion

#region variables
$dir = 'C:\Temp'
#endregion

#region Retrieving current ACLs
#Get the ACL
Get-Acl $dir

#Examine the Access property
(Get-Acl $dir).Access

#Other format
Get-Acl $dir | Select-Object -ExpandProperty Access

#Format the output
(Get-Acl $dir).Access | Format-Table

#Additional useful stuff
#filtering for a user or group
(Get-Acl $dir).Access | Where-Object {$_.IdentityReference -like '*sysah'} | Format-Table

#Finding uninherited permissions
(Get-Acl $dir).Access | Where-Object {-not $_.IsInherited} | Format-Table

#endregion

#region Setting Acls
#current ACLs
(Get-ACL "$dir\dog.txt").Access | Format-Table
(Get-ACL "$dir\cat.txt").Access | Format-Table

#Copy dog to cat
$ACL = Get-Acl "$dir\Dog.txt"
Set-Acl -Path "$dir\Cat.txt" -AclObject $ACL

#Check cat
(Get-ACL "$dir\cat.txt").Access | Format-Table

#region Add an ACE to an existing ACL on a folder
#Create the ACE
$identity = 'techsnipsdemo\Fido'
$rights = 'FullControl' #other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
<#
Inheritance is what types child objects the ACE applies to. With a filesystem, containers = folders, objects = files.

Propagation controls which generation of child objects the ACE is restricted to. None = ACE applies to all.
InheritOnly = ACE applies only to children and grandchildren, not to target folder. NoPropagateInherit = Target folder
and target folder children, not grandchildren.

https://msdn.microsoft.com/en-us/library/ms229747(v=vs.110).aspx
#>
$inheritance = 'ContainerInherit, ObjectInherit' #other options: [enum]::GetValues('System.Security.AccessControl.InheritanceFlags')
$propagation = 'None' #other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #other options: [enum]::GetValues('System.Security.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)

#Add ACE to ACL
$ACL = Get-Acl $dir
$ACL.AddAccessRule($ACE)

#Set-Acl
Set-Acl $dir -AclObject $ACL

#Verify
(Get-ACL $dir).Access | Format-Table
#endregion

#region Remove an ACE on an existing ACL on a file
#Get existing ACL
(Get-Acl "$dir\cat.txt").Access | Format-Table
$ACL = Get-Acl "$dir\cat.txt"

#Filter for the ACE to remove
$ACE = $ACL.Access | Where-Object {($_.IdentityReference -eq 'techsnipsdemo\Fido') -and -not ($_.IsInherited)}

#Remove the ACE
$ACL.RemoveAccessRule($ACE)

#Set the ACL
Set-Acl "$dir\cat.txt" -AclObject $ACL

#Verify
(Get-Acl "$dir\cat.txt").Access | Format-Table
#endregion

#endregion

#region Scripting ACLs
#variables
$share = 'C:\Share'
$folders = Get-ChildItem $share -Directory

$domain = 'techsnipsdemo'
$rights = 'Modify'
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None'
$type = 'Allow'

#script
ForEach($folder in $folders){
    Write-Host "Working on $($folder.name)"
    If(Get-ADGroup $folder.Name){
        Write-Host ' -Creating ACE'
        $identity = "$domain\$($folder.name)"
        $ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
        $ACL = Get-Acl $folder.FullName
        Write-Host ' -Adding ACE to ACL'
        $ACL.AddAccessRule($ACE)
        Write-Host ' -Applying new ACL to folder'
        Set-Acl $folder.FullName -AclObject $ACL
    }
}
#endregion

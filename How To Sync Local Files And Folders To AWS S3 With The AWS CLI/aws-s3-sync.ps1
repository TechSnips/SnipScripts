# Documentation: https://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html

# List available buckes & check contents
aws s3 ls
aws s3 ls s3://techsnips-sync

# Single file = copy
aws s3 cp 'C:\Documents\Very Important Memo.docx' s3://techsnips-sync/

# Multiple files\directories = sync
aws s3 sync 'C:\Backup' s3://techsnips-sync/backups

$Files = Get-ChildItem -Path 'C:\Backup' -Recurse
$Files.Count
($Files | Measure -Sum Length).Sum / 1MB

# Options (Include/Exclude & Permissions)
Get-ChildItem 'D:\Scripts'

$LongCommand = "aws s3 sync 'D:\Scripts' s3://techsnips-sync/scripts " +
               "--exclude '*' --include '*.ps1' " +
               "--grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers"
Invoke-Expression $LongCommand

aws s3 ls s3://techsnips-sync/scripts/

Remove-Item D:\Scripts\10_parallel.ps1

Invoke-Expression $LongCommand

$LongCommand = "aws s3 sync 'D:\Scripts' s3://techsnips-sync/scripts " +
               "--exclude '*' --include '*.ps1' " +
               "--grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers " +
               "--delete"
Invoke-Expression $LongCommand

Copy-Item -Path 'D:\OtherScripts\*' -Destination 'D:\Scripts\'

aws s3 ls s3://techsnips-sync
aws s3 ls s3://techsnips-sync/scripts/
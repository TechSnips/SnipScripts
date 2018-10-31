Import-Module grouppolicy 

#region Simple Backup

Get-GPO -All

Get-GPO -All | Backup-GPO -Path 'c:\GPO_Backup'

#endregion


#region Named Directory

$GPO = Get-GPO -Name HR

$BackupDestination = 'c:\GPO_Backup\' + $GPO.DisplayName

New-Item -Path $BackupDestination -ItemType directory

$GPO | Backup-GPO -Path $BackupDestination

#endregion

#region Modification Time

$GPO = Get-GPO -Name HR

$pattern = '[^a-zA-Z0-9\s]'

$ModificationTime = $GPO.ModificationTime -replace $pattern,''

$BackupDestination = 'c:\GPO_Backup\' + $GPO.DisplayName + '\' + $ModificationTime + '\'

New-Item -Path $BackupDestination -ItemType directory | Out-Null

$GPO | Backup-GPO -Path $BackupDestination

#endregion

#region DisplayName

$GPO = Get-GPO -Name "Add Shortcut!¯\_(ツ)_/¯"

$pattern = '[^a-zA-Z0-9\s]'

$DisplayName = $GPO.DisplayName -replace $pattern,''

$ModificationTime = $GPO.ModificationTime -replace $pattern,''

$BackupDestination = 'c:\GPO_Backup\' + $DisplayName + '\' + $ModificationTime + '\'

New-Item -Path $BackupDestination -ItemType directory | Out-Null

$GPO | Backup-GPO -Path $BackupDestination

#endregion

#region Backup all the things

$AllGPOs = Get-GPO -All

foreach ($GPO in $AllGPOs) {

  $pattern = '[^a-zA-Z0-9\s]'

  $DisplayName = $GPO.DisplayName -replace $pattern,''

  $ModificationTime = $GPO.ModificationTime -replace $pattern,''

  $BackupDestination = 'c:\GPO_Backup\' + $DisplayName + '\' + $ModificationTime + '\'


  if (-Not (Test-Path $BackupDestination)) {

      New-Item -Path $BackupDestination -ItemType directory | Out-Null

      Backup-GPO -Name $GPO.DisplayName -Path $BackupDestination

      }

  } 

#endregion
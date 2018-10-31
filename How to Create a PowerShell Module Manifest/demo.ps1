#region Let's create a module with a single function

New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\Software' -ItemType Directory
New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psm1' -ItemType File
Add-Content -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psm1' -Value 'function Get-Software {}'

Get-Content -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psm1'

Get-Module -Name Software -ListAvailable | Select-Object -Property Author, RootModule, Description

#endregion

#region Creating a manifest
New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psd1' -Author 'Adam Bertram' -RootModule Software.psm1 -Description 'This module helps in deploying software.'

Get-Content -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psd1'

Get-Module -Name Software -ListAvailable | Select-Object -Property Author, RootModule, Description

## For more information: https://technet.microsoft.com/en-us/library/dd878297(v=vs.85).aspx
#endregion
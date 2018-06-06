
$env:PSModulePath -split ';'


#region PSModulePAth
$origPSModulePath = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PSModulePath).PSModulePath

$origPSModulePath
        
$env:PSModulePath += ";$env:userprofile\Documents\WindowsPowerShell\Modules;$env:programfiles\WindowsPowerShell\Modules;$origPSModulePath"
#endregion

#region Module
Install-Module WindowsPSModulePath -Force
#endregion
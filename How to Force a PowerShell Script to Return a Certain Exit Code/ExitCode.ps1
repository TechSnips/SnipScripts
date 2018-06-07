
#region Exit 0
. ./exit0.ps1
$LASTEXITCODE
#endregion

#region Exit('99')
. ./exit99.ps1
$LASTEXITCODE
#endregion

#region [Environment]::Exit('98')
powershell -noexit -noprofile -command {& ./SystemExit.ps1}
$LASTEXITCODE
#endregion

#region $host.SetHostExit('97')
powershell -noexit -noprofile -command {& ./SetHostExit.ps1}
$LASTEXITCODE
#endregion
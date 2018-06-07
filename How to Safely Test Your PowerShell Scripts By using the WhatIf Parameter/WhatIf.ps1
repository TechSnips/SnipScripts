
#region Using WhatIf
Remove-Item -Path c:\temp\* -WhatIf
Remove-Item -Path c:\temp\* -WhatIf:$true
$WhatIfPreference
$WhatIfPreference = $true
Remove-Item -Path c:\temp\*
#endregion
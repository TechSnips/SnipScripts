
#region $PSDefaultParameterValues
$PSDefaultParameterValues
$PSDefaultParameterValues = @{"<CmdletName>:<ParameterName>"="<DefaultValue>"}
$PSDefaultParameterValues = @{"Test-Connection:Count"="1"}
$PSDefaultParameterValues
Test-Connection -ComputerName localhost

$PSDefaultParameterValues = @{"Test-Connection:Count"="2"}
$PSDefaultParameterValues
Test-Connection -ComputerName localhost

$PSDefaultParameterValues += @{"Get-Date:Format"="r"}
$PSDefaultParameterValues.Add("Get-Date:Format","r")
$PSDefaultParameterValues["Get-Date:Format"] = "r"
$PSDefaultParameterValues
Get-Date

$PSDefaultParameterValues.Remove("Test-Connection:Count")
$PSDefaultParameterValues

$PSDefaultParameterValues.Clear()
$PSDefaultParameterValues

$PSDefaultParameterValues = @{"<CmdletName>:<ParameterName>"={<ScriptBlock>}}
$PSDefaultParameterValues = @{ "Invoke-Command:ScriptBlock"={{Get-Process -Name P*}} }
$PSDefaultParameterValues
Invoke-Command

$PSDefaultParameterValues = @{
    "Send-MailMessage:SmtpServer"="Server01AB234x5";
    "Get-WinEvent:LogName"="Microsoft-Windows-PrintService/Operational"
 }

$PSDefaultParameterValues.Add("*:Verbose",$true)
$PSDefaultParameterValues.Add("Get-*:Verbose",$true)
Get-CimInstance -ClassName Win32_OperatingSystem  | Select-Object Version, BuildNumber

$PSDefaultParameterValues.Add("Disabled",$true)
$PSDefaultParameterValues
Get-CimInstance -ClassName Win32_OperatingSystem  | Select-Object Version, BuildNumber

$PSDefaultParameterValues.Remove("Disabled")
$PSDefaultParameterValues
#endregion
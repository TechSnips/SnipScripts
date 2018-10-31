
#region Export-CSV
Get-Service -Name Win* | Select-Object Name, Status, DisplayName | Export-Csv -Path c:\temp\services.csv
Import-Csv -Path C:\temp\services.csv
Get-Service -Name Bits | Select-Object Name, Status, DisplayName | Export-Csv -Path c:\temp\services.csv -Append
Import-Csv -Path C:\temp\services.csv
#endregion

#region Add-Content
Add-Content -Path c:\temp\employees.csv -Value "FirstName, LastName, UserName"
$Employees = @(
    '"Jason","Robinson","jrobinson"'
    '"Dan","Wilson","dwilson"'
    '"Jane","Smith","jsmith"'
)
$Employees | foreach {Add-Content -Path c:\temp\employees.csv -Value $PSItem}
Import-Csv -Path c:\temp\employees.csv
#endregion

#region Avoiding System.Object[] Output
$Info = [pscustomobject]@{
    First = 'Jason'
    Last = 'Robinson'
    Location = @('AL','US')
}
$Info | Export-Csv -Path c:\temp\info.csv
Import-Csv -Path c:\temp\info.csv

$Info = [pscustomobject]@{
    First = 'Jason'
    Last = 'Robinson'
    Location = (@('AL','US') -join ',')
}
$Info | Export-Csv -Path c:\temp\info.csv
Import-Csv -Path c:\temp\info.csv

$Info = [pscustomobject]@{
    First = 'Jason'
    Last = 'Robinson'
    Location = (@('AL','US') | Out-String).Trim()
}
$Info | Export-Csv -Path c:\temp\info.csv
Import-Csv -Path C:\temp\info.csv | Format-List
#endregion
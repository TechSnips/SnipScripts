<#
    Prerequisites:
    Pester Module from the PS Gallery
    Report unit (https://www.nuget.org/packages/ReportUnit/1.5.0-beta1)

    SNIPS
    How to Execute Pester Tests
    Installing The Pester PowerShell Module
    Scaffolding New Pester Tests With New-Fixture in PowerShell
#>

#region
#Pester Code
Invoke-Pester -Path E:\techsnip\pestertest.ps1
Invoke-Pester -Path E:\techsnip\pestertest.ps1 -OutputFormat  NUnitXml `
 -OutputFile E:\techsnip\ReportUnit\Tests\mypc.xml -Quiet
 ii E:\techsnip\ReportUnit\Tests\mypc.xml
#endregion

#region
#Report Unit
E:\techsnip\ReportUnit\ReportUnit.exe E:\techsnip\ReportUnit\Tests E:\techsnip\ReportUnit\results
ii E:\techsnip\ReportUnit\results\mypc.html
#endregion
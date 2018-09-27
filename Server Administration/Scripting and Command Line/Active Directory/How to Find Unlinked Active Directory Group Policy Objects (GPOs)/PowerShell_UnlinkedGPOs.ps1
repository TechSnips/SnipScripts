#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region The stuff to know!

#Get all GPOs
Get-GPO -All | Format-Table DisplayName
$GPOs = Get-GPO -All

#Get a GPO report
Get-GPOReport $GPOs[0].Id -ReportType XML
[xml]$GPOReport = Get-GPOReport $GPOs[1].Id -ReportType XML

#Find the LinksTo property
$GPOReport
$GPOReport.GPO
$GPOReport.GPO.LinksTo

#Return GPOs without any value in the LinksTo property of their GPO report
ForEach($GPO in Get-GPO -All){
    [xml]$GPOReport = Get-GPOReport $GPO.Id -ReportType XML
    If(-not ($GPOReport.GPO.LinksTo)){
        $GPO
    }
}

#endregion

#region Make it a function

Function Get-UnlinkedGPOs{
    ForEach($GPO in Get-GPO -All){
        [xml]$GPOReport = Get-GPOReport $GPO.Id -ReportType XML
        If(-not ($GPOReport.GPO.LinksTo)){
            $GPO
        }
    }
}

Get-UnlinkedGPOs

#endregion
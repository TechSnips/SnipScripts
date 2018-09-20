#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Getting started

#Starting a single job
Start-Job -Name MyFirstJob -ScriptBlock {Write-Host 'Hello World!'}

#Get job
Get-Job

#Receive job data
Get-Job | Receive-Job

#Removing the job
Get-Job | Remove-Job

#Starting many jobs
1..10 | ForEach-Object {
    Start-Job -Name $_ -ScriptBlock {"Hello World from $($args[0])"} -ArgumentList $_
}

#Looking at current jobs
Get-Job

#Receiving jobs
Get-Job | Select-Object -First 5 | Receive-Job

#Receiving jobs into a variable
$ReceivedJobs = Get-Job | Receive-Job
$ReceivedJobs

#Remove jobs
Get-Job | Remove-Job

#Only completed jobs
Get-Job | Where-Object State -eq 'Completed' | Remove-Job

#endregion

#region Real world example
#Source: https://moz.com/top500
$Top500Websites = Import-Csv 'D:\TechSnips\top500.domains.05.18.csv'

#What the object looks like
$Top500Websites[0]

$Top500Websites | Select-Object -First 25 | ForEach-Object {
    Test-Connection $_.url.replace('/','') -Count 1 -Quiet
}

$Top500Websites | Select-Object -First 25 | ForEach-Object {
    Start-Job -Name $_.url.replace('/','') -ScriptBlock {
        Test-Connection $args[0].replace('/','') -Count 1 -Quiet
    } -ArgumentList $_.Url
}

#Reviewing running jobs
Get-Job

#Receive jobs
Get-Job | Where-Object HasMoreData -eq $true | Receive-Job

#Remove jobs
Get-Job | Remove-Job

#Create usable return data
$Top500Websites | Select-Object -First 25 | ForEach-Object {
    Start-Job -Name $_.url.replace('/','') -ScriptBlock {
        [PSCustomObject]@{
            URL = $args[0]
            Ping = Test-Connection $args[0].replace('/','') -Count 1 -Quiet
        }
    } -ArgumentList $_.Url
}

#Reviewing running jobs
Get-Job

#Receive jobs
$ReceivedJobs = @()
$ReceivedJobs = Get-Job | Where-Object HasMoreData -eq $true | Receive-Job

$ReceivedJobs.Count

#If we missed any
$ReceivedJobs += Get-Job | Where-Object HasMoreData -eq $true | Receive-Job

$ReceivedJobs | Format-Table url,ping

#endregion
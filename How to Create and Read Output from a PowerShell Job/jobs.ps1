Get-Command -Noun Job

$job = Start-Job -Nam 'Write hostname' -ScriptBlock { hostname }
$job

Get-Job

Get-Job -State Completed

Get-Job -Id $job.Id

Get-Job -Id $job.Id | Receive-Job
Get-Job -Id $job.Id | Receive-Job

$job = Start-Job -Nam 'Write hostname' -ScriptBlock { hostname }
Get-Job -Id $job.Id | Receive-Job -Keep
Get-Job -Id $job.Id | Receive-Job -Keep
Get-Job -Id $job.Id | Receive-Job -Keep


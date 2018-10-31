$html = @()

$computerName = $env:COMPUTERNAME

$html += "<h1>$computerName</h1>"

$services = Get-Service | Group-Object StartType | Sort-Object Name

foreach ($startType in $services) {
    $name = $startType.Name
    $group = $startType.Group

    $html += $group | select Name,DisplayName,StartType,Status | ConvertTo-Html -As Table -Fragment -PreContent "<h2>$name</h2>"
}

$date = Get-Date
$user = $env:USERNAME

$html += "<br><i>Run by $user at $date</i>"

ConvertTo-Html -Title 'Services' -Body $html | Out-File .\service2.html

start .\service2.html


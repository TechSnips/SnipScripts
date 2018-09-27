$SystemFrontierURI = 'http://systemfrontier.techsnips.io:8080/api/job'

$Params = @{
    Target = 'workstation1;workstation2;workstation3'
    Depth  = 2
}

$Tool = @{
    CustomToolID = "f7f47639-db94-4312-a6ef-fdfcc0e688c1"
    TargetClass  = "Computer"
    Parameters   = $Params
}

$JSON = ConvertTo-Json @(,$Tool)

$RestParams = @{
    Method                = 'Post'
    Uri                   = $SystemFrontierURI
    Body                  = $JSON
    ContentType           = 'application/json'
    UseDefaultCredentials = $true
}
$Job = Invoke-RestMethod @RestParams

$Result = Invoke-RestMethod -Method Get -Uri "$SystemFrontierURI/$Job" -UseDefaultCredentials

foreach ($Task in $Result.Tasks) {
    $Task | Select TargetName, Result
}
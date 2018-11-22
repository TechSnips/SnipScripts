$server = 'server2'

# Get the Current LCM settings for $server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager).AgentId}

$AgentId = "DCE578A5-607F-11E8-B2B6-00155D010415"  # Agent ID of the Node

function GetReport
{
    param($AgentId)

    # DSC Web Service URL
    $serviceURL = "http://server2019:8080/PSDSCPullServer.svc"

    # Build a request URL to pass to Invoke-WebRequest
    $requestUrl = "$serviceURL/Nodes(AgentId='$AgentId')/Reports"

    # Request the DSC reports for the desired agent id
    $request = Invoke-WebRequest -Uri $requestUrl  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"}

    # Convert the output from the web request from JSON
    $object = ConvertFrom-Json $request.content
    return $object.value
}

# Get DSC LocalConfigurationManager reports sorted by StartTime and select the first one
$report = GetReport -AgentId $agentID | where OperationType -eq 'Consistency' | sort StartTime -Descending | select -First 1
$report 

# Convert StatusData from JSON
$statusData = $report.StatusData | ConvertFrom-Json
$statusData

$statusData.ResourcesInDesiredState

$statusData.ResourcesNotInDesiredState

$statusData.MetaConfiguration


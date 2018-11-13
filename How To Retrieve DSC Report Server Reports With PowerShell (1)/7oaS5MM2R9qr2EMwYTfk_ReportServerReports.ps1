
$server = ''

# Verify that the ReportManagers property has been configured to send reports to a Pull Server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager).ReportManagers}

# Get the Current LCM settings for $server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager)}

# Web service URL format:
# http://REPORTSERVER:8080/PSDSCReportServer.svc/Nodes(AgentId='MyNodeAgentId')/Reports

$AgentId = "3BACC5C1-6293-11E8-B2B5-00155D010416"             # Agent ID of the Node
$serviceURL = "http://server2019:8080/PSDSCPullServer.svc"    # DSC Web Service URL

# Build a request URL to pass to Invoke-WebRequest
$requestUrl = "$serviceURL/Nodes(AgentId='$AgentId')/Reports" # URL for query
$requestUrl

# Request the DSC reports for the desired agent id
$request = Invoke-WebRequest -Uri $requestUrl  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
        -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"}

$request.content

# Convert the output from the web request from JSON
$Object = ConvertFrom-Json $request.Content
$Object.value

function GetReport
{
    param
    (
        $AgentId, 
        $serviceURL = "http://server2019:8080/PSDSCPullServer.svc"
    )

    $requestUrl = "$serviceURL/Nodes(AgentId='$AgentId')/Reports"
    $request = Invoke-WebRequest -Uri $requestUrl  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"}
    $object = ConvertFrom-Json $request.content
    return $object.value
}

# Get DSC reports for $agentID
GetReport -AgentId $agentID 

# Get DSC Consistency reports sorted by StartTime and select the first one
$report = GetReport -AgentId $agentID | where OperationType -eq 'Consistency' | sort StartTime -Descending | select -First 1
$report

# Get StatusData from report 
$report.StatusData

# Convert StatusData from JSON
$statusData = $report.StatusData | ConvertFrom-Json
$statusData

# Get resources that in or out of desired state
$statusData.ResourcesInDesiredState



$server = 'server1'

# Verify that the ReportManagers property has been configured to send reports to a Pull Server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager).ReportManagers}

# Get the Current LCM settings for $server
Invoke-Command -ComputerName $server -ScriptBlock {(Get-DscLocalConfigurationManager).AgentId}

$AgentId = "B5FF329D-561B-11E8-B2B7-00155D010414"  # Agent ID of the Node

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
$report = GetReport -AgentId $agentID | where OperationType -eq 'LocalConfigurationManager' | sort StartTime -Descending | select -First 1
$report 

# Convert StatusData from JSON
$statusData = $report.StatusData | ConvertFrom-Json
$statusData

$statusData.MetaConfiguration
$statusData.MetaConfiguration.ConfigurationDownloadManagers

# Agent IDs of 3 DSC nodes
$AgentId = 'B5FF329D-561B-11E8-B2B7-00155D010414', 'DCE578A5-607F-11E8-B2B6-00155D010415', '3BACC5C1-6293-11E8-B2B5-00155D010416'

# Add all LocalConfigurationManager reports for DSC nodes to $reports array
$reports = @()
foreach ($id in $AgentId) {
    $reports += GetReport -AgentId $id | where OperationType -eq 'LocalConfigurationManager'
}
$reports

# Function to get the DSC node settings from the LCM reports
function GetNodeLCMSettings {
    
    param($reports)
    
    foreach ($report in $reports) {
        
        $data = $report.statusData | ConvertFrom-Json

        $settings = @{
            'HostName'             = $data.HostName
            'Status'               = $report.Status
            'ConfigurationMode'    = $data.MetaConfiguration.ConfigurationMode
            'StartDate'            = [datetime]$data.StartDate
            'RefreshFrequencyMins' = $data.MetaConfiguration.RefreshFrequencyMins
            'ConfigurationNames'   = $data.MetaConfiguration.ConfigurationDownloadManagers.ConfigurationNames
            'Errors'               = $data.error
        }

        $object = New-Object -TypeName PSObject -Property $settings
        $object | select HostName,Status,ConfigurationMode,ConfigurationNames,RefreshFrequencyMins,StartDate,Errors
    }
}

# Get Node LCM Settings from report data
GetNodeLCMSettings -reports $reports | Format-Table

# Get the LCM Settings of Server3 sorted by date
GetNodeLCMSettings -reports $reports | where HostName -eq 'Server3' | Sort-Object StartDate | Format-Table


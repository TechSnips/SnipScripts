$Url = 'buff.ly/2sWvPOH'

$Web = Invoke-WebRequest -Uri $Url -UseBasicParsing

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Web.BaseResponse.ResponseUri.AbsoluteUri

function Expand-Uri {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [Alias('URL')]
        [uri[]] $Uri
    )

    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    process {
        foreach ($Link in $Uri) {
            $Response = Invoke-WebRequest -Uri $Link -UseBasicParsing
            $Response.BaseResponse.ResponseUri.AbsoluteUri
        }
    }
}

Expand-Uri 'https://t.co/rHrCyVMNA3'

'buff.ly/2sWvPOH', 'zpr.io/6FPjh' | Expand-Uri
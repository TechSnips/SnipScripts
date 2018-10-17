<#
.SYNOPSIS
 This is a simple TCP Port scanner script

.DESCRIPTION
 This is a simple TCP Port scanner script and a wrapper of Test-NetConnection 

.PARAMETER Ports
List of Ports to scan

.PARAMETER ComputerName
Target IP Address or FQDN

.EXAMPLE
Scan-Computer -ComputerName "127.0.0.1" -Ports (443, 1433, 3389) 

.EXAMPLE
Scan-Computer -ComputerName "10.0.0.10" -Ports (1..65535) 

.NOTES
-PSScriptAnalyzer will mark "SCAN" as unapproved Verb.
-Author: Paolo Frigo for TechSnips.io
#>
function Scan-Computer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int[]]$Ports,
        [Parameter(Mandatory=$true)]
        [string] $ComputerName
    )

    $OpenPorts = @()
    if (Test-Connection -ComputerName $ComputerName -Quiet -Count 1){
        foreach ($PortNumber in $Ports) {
            if ((Test-NetConnection -ComputerName $ComputerName -Port $PortNumber -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).TcpTestSucceeded ) { 
                $OpenPorts += $PortNumber        
            }   
        }
        if ($OpenPorts) {
            Write-Output "[OPEN PORTS]"
            $OpenPorts 
        }
    }
    else{
        Write-Warning "[$ComputerName] - Host unreachable, please try again later."
    }   
}


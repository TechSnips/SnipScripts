param (
    [String] $ComputerName,
    [Int] $Depth = 2
)

if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
    $Items = Get-ChildItem -Path "\\$ComputerName\C$" -Filter '*.pst' -Depth $Depth -ErrorAction SilentlyContinue
    
    if ($Items) {
        $Items.FullName
    } else {
        Write-Output'No PST found'
    }
} else {
    Write-Output "Not responding to ping"
}
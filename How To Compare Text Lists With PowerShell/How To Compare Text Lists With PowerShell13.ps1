
$List1 = (Get-Content .\List1.txt).trim().ToLower()
$List2 = (Get-Content .\List2.txt).trim().ToLower()

$FullList = $List1 + $List2 | select -uniq

$report = @()

foreach ($item in $FullList) {

    If ($List1.Contains($item)) {
        $ExistsInList1 = $true
    }
    else {
        $ExistsInList1 = $false
    }

    If ($List2.Contains($item)) {
        $ExistsInList2 = $true
    }
    else {
        $ExistsInList2 = $false
    }

    $report += New-Object psobject -Property @{Item=$item;List1=$ExistsInList1;List2=$ExistsInList2}

}

$report | select Item, List1, List2 | Export-Csv -Path Report.csv -NoTypeInformation


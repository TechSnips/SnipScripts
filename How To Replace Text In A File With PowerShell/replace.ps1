<#
    Prerequisites:
    Just Powershell !

    Notes:
#>

(Get-Content E:\video\sls\w3.txt).replace('SIGN', 'TECHSNIP') | Set-Content E:\video\sls\w3.txt

(Get-Content E:\video\sls\w3.txt).replace('A graphics file illustrating', 'A text file showing') | Set-Content E:\video\sls\w3.txt

$ips = Get-Content E:\video\sls\ip.txt 
$ips -replace "\.\d{2}\.", ".10."
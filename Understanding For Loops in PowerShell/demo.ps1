## When you need to run an expression X number of times
Write-Host 1
Write-Host 2
Write-Host 3
Write-Host 4
Write-Host 5

<#
for (<iterator> = <integer>; <expression to run while equals true>; <iterator increment>) {
    Write-Host $i
}
#>
for ($i = 4; $i -lt 10; $i++) {
	Write-Host $i
}
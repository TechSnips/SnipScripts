## Scriptblocks are "portable" expressions

#region Creating and running scriptblocks
$myscriptblock = { 1 + 1 }
$myscriptblock.GetType().FullName
& $myscriptblock

Invoke-Command -ScriptBlock $myscriptblock

#endregion

#region Scriptblock parameters
$myscriptblock = { param($String,$Number) 1 + $Number; $String }
& $myscriptblock 'foo' 3
Invoke-Command -ScriptBlock $myscriptblock -ArgumentList 3
#endregion

#region Variables in scriptbnlocks
$variable = 'foo'
$myscriptblock = { "$variable bar" }
& $myscriptblock

## Passing variables to expressions in scriptblocks
$myscriptblock = [scriptblock]::Create("$variable bar")

## scoping
$i = 2
$scriptblock = { "Value of i is $i" }
$i = 3
& $scriptblock

## Capturing variables rather than by reference
$i = 2
$scriptblock = { "Value of i is $i" }.GetNewClosure()
$i = 3
& $scriptblock
#endregion
#region Creating arrays
$colorPicker = @('blue', 'white', 'yellow', 'black')
$example = @('blue', 0, (whoami), 'black')
#endregion

#region Reading Array Elements

## Everything is returned. If the index doesn't exist, nothing is returned

## Individual elements
$colorPicker[0]
$colorPicker[2]
$colorPicker[3]

## Multiple elements
$colorPicker[0..1]

## Looking backward
$colorPicker[-1]

## No output
$colorPicker[4]

## Ensure an error is thrown if an unknown index is used
Set-StrictMode -Version Latest
$colorPicker[4]

## Find elements in an array
$blueIndexNumber = $colorPicker.IndexOf('blue')
$colorPicker[$blueIndexNumber]
$colorPicker | Where-Object -FilterScript { $_ -eq 'blue' }

#endregion

#region Adding Array Elements

$colorPicker = $colorPicker + 'orange'
$colorPicker

## shortcut
$colorPicker += 'brown'
$colorPicker

#endregion

#### Modifying Array Elemments

$colorPicker[1] = 'pink'

#### Not All Arrays are Alike

$colorPicker.Remove('brown')

$colorPicker = [System.Collections.ArrayList]@('blue', 'white', 'yellow', 'black')

$colorPicker.Add('gray')

$null = $colorPicker.Add('gray')

## Index number not needed
$colorPicker.Remove('gray')

## unary operator to inspect arrays
$colorPicker | Get-Member
,$colorPicker | Get-Member
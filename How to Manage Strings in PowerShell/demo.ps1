#region Error thrown when no quotes are used because PowerShell thinks blue is an expression
$color = blue
#endregion

#region Creating a string using quotes
$color = "yellow"
$color

$color = 'red'
$color
#endregion

#region Concatenation
$message = 'Down server: '
$message += 'SRV1'
$message

$message = 'Down server: '
$message + 'SRV1'
$mess
#endregion

#region String formatting
$message = 'Down server: '
'{0}SRV1' -f $message
#endregion

#region String interpolation
$language = 'PowerShell'
$color = 'blue'
$name = 'George'

## I'd now like to create a sentence that contains all of these string variables that looks like this:

## Today, George learned that PowerShell loves the color blue.

## This doesn't work
Today, $name learned that $language loves the color $color.

## Single quotes PowerShell treats variables literally
'Today, $name learned that $language loves the color $color'

## Using double quotes expands the variables and outputs the values
"Today, $name learned that $language loves the color $color"
#endregion

#region String methods
$string = 'Foo '

## We have a space on the end
"$string--"

## Still a space. Need to capture the output
$string.Trim(' ')
"$string --"

$string = $string.Trim(' ')
"$string --"

$string.Length

$string.ToUpper()
$string.ToLower()

$string.StartsWith('D')
$string.StartsWith('U')

$string | Get-Member
#endregion
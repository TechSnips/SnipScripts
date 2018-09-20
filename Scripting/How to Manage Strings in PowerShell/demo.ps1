#region Error thrown when no quotes are used because PowerShell thinks blue is an expression
$color = blue
cls
#endregion

#region Creating a string using quotes
$color = "yellow"
$color

$color = 'red'
$color
cls
#endregion

#region Concatenation
$message = 'Down server: '
$message += 'SRV1'
$message

$message = 'Down server: '
$message = $message + 'SRV1'
$message
cls
#endregion

#region String formatting
$message = 'Down server: '
'{0}{1}SRV1' -f $message,'blah'
cls
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
cls
#endregion

#region String methods
$string = 'Foo '

## We have a space on the end
"$string--"
cls

## Still a space. Need to capture the output
$string.Trim(' ')
"$string --"
cls

$string = $string.Trim(' ')
"$string--"
cls

$string.Length

$string.ToUpper()
$string.ToLower()

$string.StartsWith('D')
$string.StartsWith('F')

$string | Get-Member
#endregion
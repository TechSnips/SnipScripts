<#
switch (<expression>) {
	<expressionvalue> {
		## Do something with code here.
	}
	default {
		## Stuff to do if no matches were found
	}
}
#>

#region Switch statement
$season = 'Summer'
switch ($season) {
	'Summer' {
		Write-Host "The season is [$_]."
	}
    'Summer' {
		Write-Host "The season is [$_]."
	}
	'Fall' {
		Write-Host "The season is [$_]."
	}
	'Winter' {
		Write-Host "The season is [$_]."
	}
    'Spring' {
		Write-Host "The season is [$_]."
	}
	default {
		Write-Host 'Unknown season'
	}
}
#endregion

#region Using the break keyword
switch ($season) {
	'Summer' {
		Write-Host "The season is [$_]."
        break
	}
    'Summer' {
		Write-Host "The season is [$_]."
        break
	}
	'Fall' {
		Write-Host "The season is [$_]."
        break
	}
	'Winter' {
		Write-Host "The season is [$_]."
        break
	}
    'Spring' {
		Write-Host "The season is [$_]."
        break
	}
	default {
		Write-Host 'Unknown season'
	}
}
#endregion

#region Assigning to a variable
$message = switch ($season) {
	'Summer' {
		"The season is [$_]."
        break
	}
	'Fall' {
		"The season is [$_]."
        break
	}
	'Winter' {
		"The season is [$_]."
        break
	}
    'Spring' {
		"The season is [$_]."
        break
	}
	default {
		'Unknown season'
	}
}
#endregion

#region Process all elements in an array
$seasons = 'Summer','Fall'
switch ($seasons) {
	'Summer' {
		"The season is [$_]."
	}
	'Fall' {
		"The season is [$_]."
	}
	'Winter' {
		"The season is [$_]."
	}
    'Spring' {
		"The season is [$_]."
	}
	default {
		'Unknown season'
	}
}
#endregion

#region Wildcard
$shortSeason = 'Summdfdfd'
switch -Wildcard ($shortSeason) {
	'Summ*' {
		'Summer'
	}
	'Fal*' {
		'Fall'
	}
	'Win*' {
		'Winter'
	}
    'Spr*' {
		'Spring'
	}
	default {
		'Unknown season'
	}
}
#endregion

#region Regex
$season = 'Summer'
switch -Regex ($season) {
	'^Summ' {
		'Summer'
	}
	'^Fal' {
		'Fall'
	}
	'^Win' {
		'Winter'
	}
    '^Spr' {
		'Spring'
	}
	default {
		'Unknown season'
	}
}
#endregion

#region Scriptblocks
$age = 38
switch ($age) {
	{$_ -lt $_ } {
		'You are young!'
	}
	{$_ -ge $_ } {
		'You are old!'
	}
	default {
		'Unknown age'
	}
}
#endregion
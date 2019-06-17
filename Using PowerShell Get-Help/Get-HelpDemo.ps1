# Help please! PowerShell Help to the rescue
Get-help

# Let's make it easier and avoid scrolling
Get-help | more

# Even easier 'help' is an alias for get-help | more
help

# Less typing is helpful
help Get-Date

# How about examples?
help Get-Date -Examples

# Try out an example
Get-Date -DisplayHint Date

# All the details
help Get-Date -Detailed

# All the above combined
help Get-Date -Full

# Get help via a web page assuming there is a connection to the Internet
help Get-Date -Online

# Get help on concepts such as Help comments
help about_Comment_Based_Help

# Get help on the help command
help get-help

# Update help for this system for all installed PowerShell modules (run as Administrator)
Start-Process PowerShell -Verb RunAs Update-help
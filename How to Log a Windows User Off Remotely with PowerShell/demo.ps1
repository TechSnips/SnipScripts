#region Getting comfortable with the basics

## Run quser on the local machine to see output
quser

## Ensure a user is interactively logged into the remote computer

## Run quser via PowerShell remoting on a remote computer
Invoke-Command -ComputerName 'REMOTECOMPUTER' -ScriptBlock { quser }

## Use the session ID that quser returns and pass that to logoff to log off a user
Invoke-Command -ComputerName 'REMOTECOMPUTER' -ScriptBlock { logoff <Session ID> }

## Confirm the user has been logged off
Invoke-Command -ComputerName 'REMOTECOMPUTER' -ScriptBlock {quser}

#endregion

#region Getting more advanced

## Create a scriptblock to only find sessions from a single user and only log those sessions off

$scriptBlock = {
    $ErrorActionPreference = 'Stop'

    try {
        ## Find all sessions matching the specified username
        $sessions = quser | Where-Object {$_ -match 'abertram'}
        ## Parse the session IDs from the output
        $sessionIds = ($sessions -split ' +')[2]
        Write-Host "Found $(@($sessionIds).Count) user login(s) on computer."
        ## Loop through each session ID and pass each to the logoff command
        $sessionIds | ForEach-Object {
            Write-Host "Logging off session id [$($_)]..."
            logoff $_
        }
    } catch {
        if ($_.Exception.Message -match 'No user exists') {
            Write-Host "The user is not logged in."
        } else {
            throw $_.Exception.Message
        }
    }
}

## Run the scriptblock's code on the remote computer
PS> Invoke-Command -ComputerName REMOTECOMPUTER -ScriptBlock $scriptBlock

#endregion

#region An example script

Invoke-UserLogoff.ps1

#endregion

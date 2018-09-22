function New-AWSBeanstalkApp {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ApplicationName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Description,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$EnvironmentType,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string[]]$CreateEnvironmentName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$DeployToEnvironmentName,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$PackageFolderPath,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$S3BucketName,

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$WaitForEnvironment = 15 ## minutes
	)

	try {
    		## Check to see if the application exists or not. If not, create a new one
		if (-not ($ebApp = Get-EBApplication -ApplicationName $ApplicationName)) {
			$ebApp = New-EBApplication -ApplicationName $ApplicationName -Description $Description
		} else {
			Write-Verbose -Message "The BeanStalk application [$($ApplicationName)] already exists."
		}
		
    		## Check to see if the environment has been created or not. If not, create it.
		$params = @{
			ApplicationName = $ApplicationName
		}
		$CreateEnvironmentName | Where-Object { $_ -notin (Get-EBEnvironment -ApplicationName $ApplicationName | Select-Object -ExpandProperty EnvironmentName) } | ForEach-Object {
			$null = New-EBEnvironment @params -EnvironmentName $_ -SolutionStackName $EnvironmentType -Tier_Type Standard -Tier_Name WebServer
		}
		
    		## Begin monitoring the environment deployment checking the Health property every minute to see if it's Green
    		## Once it's green, continue on with the function
		$stopwatch = [system.diagnostics.stopwatch]::StartNew()
		if (@(Get-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $CreateEnvironmentName).where({ $_.Health -ne 'Green'})) {
			while (($stopwatch.Elapsed.TotalMinutes -lt $WaitForEnvironment) -and (Get-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $CreateEnvironmentName).where({ $_.Health -ne 'Green'})) {
				Write-Verbose 'Waiting for environments to be created...'
				Start-Sleep -Seconds 60
			}
			if ($stopWatch.Elapsed.TotalMinutes -gt $WaitForEnvironment) {
				Write-Error -Message 'The environment creation process timed out.'
			} else {
				Write-Verbose -Message 'Envrionment creation successful!'
			}
			$stopwatch.Stop()
		} else {
			Write-Verbose -Message 'All environments already created.'
		}

		## Create a zip from the package folder
		$pkgZipPath = "$env:TEMP\$ApplicationName.zip"
		Compress-Archive -Path "$PackageFolderPath\*" -DestinationPath $pkgZipPath

		## Upload the package to S3
		Write-S3Object -BucketName $S3BucketName -File $pkgZipPath

		## Create the new version
		$verLabel = [System.DateTime]::Now.Ticks.ToString()
		$newVerParams = @{
			ApplicationName       = $ApplicationName
			VersionLabel          = $verLabel
			SourceBundle_S3Bucket = $S3BucketName
			SourceBundle_S3Key    = "$ApplicationName.zip"
		}
		$null = New-EBApplicationVersion @newVerParams
  
    		## Deploy the new version of the application to the environment and wait for the health to turn Green again
		$null = Update-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $DeployToEnvironmentName -VersionLabel $verLabel -Force
		$stopwatch = [system.diagnostics.stopwatch]::StartNew()
		while (($stopwatch.Elapsed.TotalMinutes -lt $WaitForEnvironment) -and (Get-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $DeployToEnvironmentName).where({ $_.Health -ne 'Green'})) {
			Write-Verbose 'Waiting for environment to update...'
			Start-Sleep -Seconds 60
		}
		if ($stopWatch.Elapsed.TotalMinutes -gt $WaitForEnvironment) {
			Write-Error -Message 'Environment updating failed.'
		} else {
			Write-Verbose -Message 'Envrionment update successful!'
		}
		$stopwatch.Stop()

	} catch {
		$PSCmdlet.ThrowTerminatingError($_)
	} finally {
    		## Clean up the temporary ZIP file that was created
		if (Get-Variable -Name pkgZipPath -ErrorAction Ignore) {
			Remove-Item -Path $pkgZipPath -Force -ErrorAction Ignore
		}
	}
}
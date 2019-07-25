<#	
	.NOTES
	===========================================================================
	 Created with: 	Visual Studio Code
	 Created on:   	07/18/2019 10:09 AM
	 Created by:   	Douglas Francis (Douglas@PoshOps.io)
	 Filename:     	Set-NewHdClusterPassword.ps1
	===========================================================================
	.DESCRIPTION
		This script will go through the following steps to change the passwords for HDInsight Clusters
		1. Change the subscription context to the subscription provided in the param
		2. Get all HDInsight clusters that exist in that sub, prompt for a selection
		3. Generate a random 32 character password
		4. Setup connection to an azure storage account in the dev subscription.
		5. Creates a bash script file to change the password as a subscription on HDInsights
		6. Uploads that bash script to the blog storage and executes it as a script action.
		7. Update the KeyVault with the new password value.
	    9. Removes the bash script from the blog storage.
	
	.PARAMETER SubName
		The name of an Azure subscription. Takes validated values "dev", "prd"

	.EXAMPLE
		PS C:\> Set-NewHdClusterPassword -SubName dev
#>

function Set-NewHdClusterPassword
{
	[CmdletBinding()]
	param (
		[ValidateSet("dev", "prd")]
		[string]$SubName
	)
	begin{
	}
		
	process{
		Write-Verbose "Setting subscription context"
		switch ($SubName)
		{
			prd {$subId = ""}
			dev {$subId = ""}
		}
		
		Set-AzureRmContext -Subscription $subId | out-null
		
		Write-Verbose "Getting HDInsight Cluster options"
		try {
			[array]$HDClusters = Get-AzureRmHDInsightCluster -ea Stop
		}
		catch {
			Write-Error "Unable to get a list of HDInsight clusters in the $SubName subscription"
			$error[0]
			break
		}
		
		# Var setup
		$uri = 'https://devscriptfiles.blob.core.windows.net/files/HDInsightsPwChange.sh'
		
		# Going through all HD clusters to display
		$numClusters = $HDClusters.count
		For ($i = 0; $i -lt $numClusters; $i++)
		{
			Write-Host -ForegroundColor Green "$($i): $(($HDClusters[$i].name))"
		}
				
		# Getting input		
		$ClusterChoice = Read-Host "Select a number to a HD cluster"
				
		Write-Verbose "Getting KeyVault Options"
		try {
			[array]$vaults = Get-AzureRmKeyVault -ea Stop
		}
		catch {
			Write-Error "Unable to get a list of KeyVaults in the $SubName subscription"
			$error[0]
			break
		}
		
		Write-Verbose "Creating a new password"
		# Code taken from here https://blogs.technet.microsoft.com/poshchap/2017/07/28/generate-a-random-alphanumeric-password/
		
		function New-AlphaNumericPassword
		{
			$c = $null
			for ($i = 1; $i -lt 33; $i++)
			{
				$a = Get-Random -Minimum 1 -Maximum 4
				switch ($a) {
					1 {$b = Get-Random -Minimum 48 -Maximum 58}
					2 {$b = Get-Random -Minimum 65 -Maximum 91}
					3 {$b = Get-Random -Minimum 97 -Maximum 123}
				}
				[string]$c += [char]$b
			}			
			$c
		}
		$pw = New-AlphaNumericPassword
		
		Write-Verbose "Setting up storage account"
		$StorageContext = New-AzureStorageContext -StorageAccountName devscriptfiles -StorageAccountKey ''
		$Container = Get-AzureStorageContainer -Name 'files' -Context $StorageContext	
		$blobs = Get-AzureStorageBlob -Container $Container.name -Context $StorageContext
		
		Write-Verbose "Creating new Password change script & uploading to blob"
		try	{
			$scriptFile = "#! /bin/bash `n 
USER=admin `n 
PASS=`"$pw`" `n 
usermod --password `$(echo `$PASS | openssl passwd -1 -stdin) `$USER `n"
		}
		catch {
			$error[0]
		}
		
		$scriptFile | Out-File $env:TEMP\HDInsightsPwChange.sh -encoding utf8
		$Container | Set-AzureStorageBlobContent -File $env:TEMP\HDInsightsPwChange.sh

		Write-Verbose "Changing password on cluster"
		Try {
			Write-Verbose  $HDClusters[$ClusterChoice].name
			Submit-AzureRmHDInsightScriptAction -ClusterName $HDClusters[$ClusterChoice].name -Name ChangePassword -NodeTypes HeadNode, ZookeeperNode, WorkerNode -Uri $uri -ErrorAction Stop
			$expiry = (get-date).addDays(69)
			Write-Output "This password will expire on $expiry"
		}
		catch {
			Write-Warning "Unable to update password on the HDInsight Cluster"
			$error[0]
			break
		}
		
		# creating the value to be put in key vault
		[System.Security.SecureString]$SecretValue = ConvertTo-SecureString -String $pw -AsPlainText -Force
			try {
                $SecretName = Read-Host "Enter KeyVault SecretName to be updated"
			    Set-AzureKeyVaultSecret -VaultName $vaults.vaultName -Name $SecretName -SecretValue $SecretValue -ErrorAction stop
			}
			catch {
				Write-Warning "Unable to update the key vault with the new password $pw"
				$error[0]
			}
		
		Write-Verbose "Cleaning up Script File"
		try {
			Remove-Item $env:TEMP\HDInsightsPwChange.sh
		}
		catch {
			Write-Warning "Removing the old script file failed. Please remove manually."
			$error[0]
		}
		try {
			Remove-AzureStorageBlob -Context $StorageContext -Blob HDInsightsPwChange.sh -Container $container.name
		}
		catch {
			Write-Warning "Unable to remove the HDInsightsPwChange.sh file from blob storage."
			$error[0]
		}
	}	
	
	end {
	}
}
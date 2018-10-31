
##################################################################################
# Prerequisites:                                                                 #
#                                                                                #
# 1. Latest version of AZCopy:                                                   #
#      Latest Stable: https://aka.ms/downloadazcopy                              #
#      Latest Preview: https://aka.ms/downloadazcopypr                           #
# 2. Documentation Link:                                                         #
#      https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy  #
#                                                                                #
# This script available at: https://github.com/TechSnips/SnipScripts             #
##################################################################################

# AZCopy basic syntax
AzCopy /Source:<source> /Dest:<destination> [Options]

# AZCopy help
AzCopy.exe /?

# Access key for the Azure Storage Account
$key = ''

# URL for the Blob Container (ex. http://mystorageaccount.blob.core.windows.net/mycontainer)
$blobURL = ''

# Move to the path of the AZCopy executable
$azCopyPath = 'C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\'
Set-Location $azCopyPath

# Uploading files to Azure

Get-ChildItem C:\Files

# Copy a single file to the Blob Container
.\AzCopy /Source:C:\Files /Dest:$blobURL /DestKey:$key /Pattern:TextFile1.txt

# Copy the contents of c:\Files to the Blob Container
.\AzCopy /Source:C:\Files /Dest:$blobURL /DestKey:$key

# Copy the contents of c:\Files to the Blob Container recursively
.\AzCopy /Source:C:\Files /Dest:$blobURL /DestKey:$key /S

# Copy only the files that match the pattern TextFile1*.txt
.\AzCopy /Source:C:\Files /Dest:$blobURL /DestKey:$key /Pattern:TextFile1*

# Copy a file to a virtual directory on Azure Storage
$blobURLFolder = 'https://techsnips01.blob.core.windows.net/snipcontainer/vd'
.\AzCopy /Source:C:\Files /Dest:$blobURLFolder /DestKey:$key /Pattern:TextFile1.txt

# Copy the contents of c:\Files to the Blob Container with verbose output to a file.
.\AzCopy /Source:C:\Files /Dest:$blobURL /DestKey:$key /S /V:c:\logs\AZCopyLog.log

notepad c:\logs\AZCopyLog.log

# Downloading files from Azure

Get-ChildItem C:\AZStorage

# Download a single file to the Blob Container
.\AzCopy /Source:$blobURL /Dest:C:\AZStorage /SourceKey:$key /Pattern:TextFile1.txt

Get-ChildItem C:\AZStorage

Remove-Item C:\AZStorage\* -Force

# Download all files from the Blob Container (/S must be specified)
.\AzCopy /Source:$blobURL /Dest:C:\AZStorage /SourceKey:$key /S

Get-ChildItem C:\AZStorage

# Copy a file from one blob container to another
$blobURL = ''
$blobURL2 = ''

.\AzCopy /Source:$blobURL /Dest:$blobURL2 /SourceKey:$key /DestKey:$key /Pattern:TextFile1.txt

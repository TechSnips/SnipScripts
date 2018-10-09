# Prerequisites - Windows 10 ISO image
<#Powershell script -removeapps.ps1 -- 
https://gallery.technet.microsoft.com/Removing-Built-in-apps-65dc387b

Please see note and website for documentation on script

#>

<#
This section discusses removing the applications from the image
prior to install
#>

#mount the windows 10 image
Mount-DiskImage -ImagePath C:\LabSources\ISOs\17763.1.180914-1434.rs5_release_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso 

#Copy files to directory Here I am using c:\media\10
Copy-Item "D:\" -Destination "C:\10" -Recurse 

#run rhe tool -install.wim is located in the sources folder.
# This will remove ALL apps WITHOUT prompting
.\removeapps.ps1 -pathtowim C:\10\sources\install.wim

#This will ask to confirm each app removel
.\removeapps.ps1 -pathtowim C:\10\sources\install.wim -selectapps $true


<#
POST INSTALL REMOVAL
This section discusses how to remove after Windows 10 Install
#>

#list apps for a specific user
Get-AppxPackage -User "<username>"

#Remove ALL apps for all Users
Get-AppxPackage -AllUsers | Remove-AppxPackage

#Remove Individual apps 

#Uninstall 3D Builder:
Get-AppxPackage *3dbuilder* | Remove-AppxPackage

#Uninstall Alarms and Clock:
Get-AppxPackage *windowsalarms* | Remove-AppxPackage

#Uninstall Calculator:
Get-AppxPackage *windowscalculator* | Remove-AppxPackage

#Uninstall Calendar and Mail:
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage

#Uninstall Camera:
Get-AppxPackage *windowscamera* | Remove-AppxPackage

#Uninstall Get Office:
Get-AppxPackage *officehub* | Remove-AppxPackage

#Uninstall Get Skype:
Get-AppxPackage *skypeapp* | Remove-AppxPackage

#Uninstall Get Started:
Get-AppxPackage *getstarted* | Remove-AppxPackage

#Uninstall Groove Music:
Get-AppxPackage *zunemusic* | Remove-AppxPackage

#Uninstall Maps:
Get-AppxPackage *windowsmaps* | Remove-AppxPackage

#Uninstall Microsoft Solitaire Collection:
Get-AppxPackage *solitairecollection* | Remove-AppxPackage

#Uninstall Money:
Get-AppxPackage *bingfinance* | Remove-AppxPackage

#Uninstall Movies & TV:
Get-AppxPackage *zunevideo* | Remove-AppxPackage

#Uninstall News:
Get-AppxPackage *bingnews* | Remove-AppxPackage

#Uninstall OneNote:
Get-AppxPackage *onenote* | Remove-AppxPackage

#Uninstall People:
Get-AppxPackage *people* | Remove-AppxPackage

#Uninstall Phone Companion:
Get-AppxPackage *windowsphone* | Remove-AppxPackage

#Uninstall Photos:
Get-AppxPackage *photos* | Remove-AppxPackage

#Uninstall Store:
Get-AppxPackage *windowsstore* | Remove-AppxPackage

#Uninstall Sports:
Get-AppxPackage *bingsports* | Remove-AppxPackage

#Uninstall Voice Recorder:
Get-AppxPackage *soundrecorder* | Remove-AppxPackage

#Uninstall Weather:
Get-AppxPackage *bingweather* | Remove-AppxPackage

#Uninstall Xbox:
Get-AppxPackage *xboxapp* | Remove-AppxPackage

#To install all apps again
Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
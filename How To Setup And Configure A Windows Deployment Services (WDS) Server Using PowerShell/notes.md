How To Setup And Configure A Windows Deployment Services (WDS) Server Using PowerShell
===============================

Summary
-------

In this snip, we will install and configure a Windows Deployment Services (WDS) Server. A rock solid and standardized deployment process for servers and clients is essential to run a world-class IT operation.  

We will Use Install-windows feature to install the WDS feature and associated tools. Then using the wdsutil command we will initialize the service by setting the remote install directory location. Finally, we will import A WinPE boot image using the Import-WdsBootImage command and a Windows 10 install image using the import-wdsInstallImage command. Finally, we will test that deployments are working by booting a test machine to a WDS  discovery image.

Recomended Snips
----------------

Prerequisite
------------

* Windows server w/ a GUI to install WDS on
* An Active Directory environment
* A Windows ISO
* A test client

Demo Script
-----------

Let's Start by Installing the Windows feature wds-deployment on our soon to be WDS Server. Be sure to include the management tools to get the WDS MMC and PowerShell module

We can see that the install completed successfully and that a reboot is not required.

Use the WDS command line utility to initialize the server, specify where you would like to store your remoteInstall, A best practice is to use a separate partition. 

I'm placing the command output in a variable because it can spew out some unhelpful warnings, just ensure that the last line says "the command completed successfully." and you know WDS is up and running.

Next, we need to add a boot image and at least 1 install image before we can really do anything with it. 

So, Let's import the boot.wim, I will specify the path to the Windows 10 Iso mounted on our WDS server. This can 30 seconds or so.

Next, we will import an install image, this is the image that will actually be deploy-able after we are done.

We should create an image group to store it in, this can be named whatever you want, but you will want to logically group your images somehow. I will call my install group "desktops".

A Wim on an install media may have several images on it, we can use the get-WindowsImage command to list the image names, then use the image name we want to import  the import-wdsInstallImage command.

At this point Our WDS server is ready to test, you can either configure PXE boot or create and use a discovery image to test. I'll boot to a discovery image I have already made on our test machine.

After we select our language and login we can see that we are connected to the WDS server and able to deploy the image we imported earlier.

Thanks for watching!

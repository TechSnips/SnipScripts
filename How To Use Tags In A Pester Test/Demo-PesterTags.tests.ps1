<#
How To Use Tags In A Pester Test
TechSnips 2018
Contributor: Bill Kindle

Pre-requisites:

What you will need for this snip:
    - Latest version of the Pester module (4.4.2 as of this recording)
    - Windows PowerShell 5.1 or PowerShell 6.1

Optional:
    - Visual Studio Code with PowerShell extension -OR- PowerShell ISE
    - Code all the things directly into PowerShell console (who hurt you?)
    
Suggested knowledge:
    - Be somewhat familiar with Pester basics. (Snips Available!)
    - Be comfortable with PowerShell.

#>

<# 
This is a basic example of using Pester's -Tag parameter. 
Tags allow you to run just one or more subsets of tests in a test
suite. This is very useful becasue you do not have to use
multiple pester test files to run multiple tests. A single test 
file with tags set will enhance your ability to run targeted tests
quickly and precisely, saving you time.
#>

# Here we are just going to test a service that should be running.
Describe -Name "Basic Pester Test Using No Tags" {
    It -Name "BITS Service is Running" {
        $svc = Get-Service -Name BITS
        $svc.Status | Should -BeExactly 'Running'
    }
}

# Here we are just going to test a service that should be stopped.
# note the use of -Tag parameter 
Describe -Name "Basic Pester Test Using a Tag" -Tag "WindowsUpdate" {
    It -Name "Windows Update Service is Stopped" {
        $svc = Get-Service -Name wuauserv
        $svc.Status | Should -BeExactly 'Stopped'
    }
}

# A single tag is great, but sometimes a test can be part of another set of tags.
Describe -Name "Basic Pester Test Using Multiple Tags" -Tag "WindowsUpdate","PatchingServices" {
    It -Name "BITS Service is Running" {
        $svc = Get-Service -Name BITS
        $svc.Status | Should -BeExactly 'Running'
    }
    It -Name "Windows Update Service is Stopped" {
        $svc = Get-Service -Name wuauserv
        $svc.Status | Should -BeExactly 'Stopped'
    }
}
# This is a different set of tests, similar tag as before but a subset test.
Describe -Name "Basic Pester Test Using Multiple Tags Part 2" -Tag "PatchingServices","Time","WinRM" {
    It -Name "W32Time Service is Running" {
        $svc = Get-Service -Name W32Time
        $svc.Status | Should -BeExactly 'Running'
    }
    It -Name "WinRM Service is Running" {
        $svc = Get-Service -Name WinRM
        $svc.Status | Should -BeExactly 'Running'
    }
    It -Name "Windows Insider Service is Stopped" {
        $svc = Get-Service -Name wisvc
        $svc.Status | Should -BeExactly 'Stopped'
    }
}

<# 
You can run both tests at once, or target the tests to be run by
specifying the -Tag parameter to be used, thus only running those 
tests that have the matching -Tag parameter assigned to the 
describe block. 
#>

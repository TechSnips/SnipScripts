describe 'MyComputer' {

  it 'Remote Desktop Services should be running' {
  (Get-Service -ComputerName localhost -Name TermService).Status | should be 'Running'
  }
  it 'This script should exist' {
  (Test-path -Path 'E:\techsnip\How To Create A Simple Pester Test Report In HTML.ps1') |  Should be $True
  } }
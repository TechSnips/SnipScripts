#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
New-Item C:\RemoveMe -ItemType Directory
New-Item C:\users\Administrator\Desktop\RemoveMe -ItemType Directory
Function Prompt(){}
Clear-Host
#endregion

#region script demo

$path = Read-Host 'Enter the new directory name '
Test-Path $path
If(Test-Path $path){
    Remove-Item $path
}
Test-Path $path

#endregion

#region Prereqs

[reflection.assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

#endregion

#region basic form

$basicForm = New-Object System.Windows.Forms.Form
$basicForm.ShowDialog()

#endregion

#region insert text box

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox

$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'

$folderForm.Controls.Add($pathTextBox)

$folderForm.ShowDialog()

#endregion

#region insert button

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$folderForm.Controls.Add($pathTextBox)
#endregion

$selectButton = New-Object System.Windows.Forms.Button

$selectButton.Text = 'Select'
$selectButton.Location = '196,23'

$folderForm.Controls.Add($selectButton)

$folderForm.ShowDialog()

#endregion

#region add action

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$folderForm.Controls.Add($pathTextBox)
$folderForm.Controls.Add($selectButton)
#endregion

$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

$selectButton.Add_Click({
    $folderBrowser.ShowDialog()
    $pathTextBox.Text = $folderBrowser.SelectedPath
})

$pathTextBox.ReadOnly = $true

$folderForm.ShowDialog()

#endregion

#region add script button

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$selectButton.Add_Click({
    $folderBrowser.ShowDialog()
    $pathTextBox.Text = $folderBrowser.SelectedPath
})
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$pathTextBox.ReadOnly = $true
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$folderForm.Controls.Add($pathTextBox)
$folderForm.Controls.Add($selectButton)
#endregion

$removeButton = New-Object System.Windows.Forms.Button

$removeButton.Location = '26,52'
$removeButton.text = 'Remove'
$removeButton.Add_Click({
    If($folderBrowser.SelectedPath){
        If(Test-Path $folderBrowser.SelectedPath){
            Remove-Item $folderBrowser.SelectedPath
        }
    }
})

$folderForm.Controls.Add($removeButton)
$folderForm.ShowDialog()

#endregion

#region Final touches

#region reused code
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$removeButton = New-Object System.Windows.Forms.Button
$selectButton.Add_Click({
    $folderBrowser.ShowDialog()
    $pathTextBox.Text = $folderBrowser.SelectedPath
})
$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$pathTextBox.ReadOnly = $true
$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$removeButton.Location = '26,52'
$removeButton.text = 'Remove'
$removeButton.Add_Click({
    If($folderBrowser.SelectedPath){
        If(Test-Path $folderBrowser.SelectedPath){
            Remove-Item $folderBrowser.SelectedPath
        }
    }
})
$folderForm.Controls.Add($pathTextBox)
$folderForm.Controls.Add($selectButton)
$folderForm.Controls.Add($removeButton)
#endregion

$okButton = New-Object System.Windows.Forms.Button
$cancelButton = New-Object System.Windows.Forms.Button

$okButton.Text = 'OK'
$okButton.Location = "56,215"

$cancelButton.Text = 'Cancel'
$cancelButton.Location = "153,215"

$folderForm.AcceptButton = $okButton
$folderForm.CancelButton = $cancelButton

$folderForm.Controls.Add($okButton)
$folderForm.controls.Add($cancelButton)

$folderForm.Text = 'Folder Form'

$folderForm.ShowDialog()

#endregion

#region whole script
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
$folderForm = New-Object System.Windows.Forms.Form
$pathTextBox = New-Object System.Windows.Forms.TextBox
$selectButton = New-Object System.Windows.Forms.Button
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$removeButton = New-Object System.Windows.Forms.Button
$okButton = New-Object System.Windows.Forms.Button
$cancelButton = New-Object System.Windows.Forms.Button

$pathTextBox.Location = '23,23'
$pathTextBox.Size = '150,23'
$pathTextBox.ReadOnly = $true

$selectButton.Text = 'Select'
$selectButton.Location = '196,23'
$selectButton.Add_Click({
    $folderBrowser.ShowDialog()
    $pathTextBox.Text = $folderBrowser.SelectedPath
})

$removeButton.Location = '26,52'
$removeButton.text = 'Remove'
$removeButton.Add_Click({
    If($folderBrowser.SelectedPath){
        If(Test-Path $folderBrowser.SelectedPath){
            Remove-Item $folderBrowser.SelectedPath
        }
    }
})

$okButton.Text = 'OK'
$okButton.Location = "56,215"

$cancelButton.Text = 'Cancel'
$cancelButton.Location = "153,215"

$folderForm.AcceptButton = $okButton
$folderForm.CancelButton = $cancelButton
$folderForm.Text = 'Folder Form'

$folderForm.Controls.Add($pathTextBox)
$folderForm.Controls.Add($selectButton)
$folderForm.Controls.Add($removeButton)
$folderForm.Controls.Add($okButton)
$folderForm.controls.Add($cancelButton)

$folderForm.ShowDialog()

#endregion
#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
New-Item C:\RemoveMe -ItemType Directory
New-Item C:\RemoveMe2 -ItemType Directory
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

Add-Type -AssemblyName PresentationFramework

#endregion

#region basic window
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window"
/>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$window.ShowDialog()

#endregion

#region create grid

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$window.ShowDialog()

#endregion

#region insert text box
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        
        <TextBox x:Name = "PathTextBox"
            Width="150"
            Grid.Column="0"
            Grid.Row="0"
        />
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$window.ShowDialog()

#endregion

#region insert buttons

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        
        <TextBox x:Name = "PathTextBox"
            Width="150"
            Grid.Column="0"
            Grid.Row="0"
        />
        <Button x:Name = "ValidateButton"
            Content="Validate"
            Grid.Column="1"
            Grid.Row="0"
        />
        <Button x:Name = "RemoveButton"
            Content="Remove"
            Grid.Column="0"
            Grid.Row="1"
        />
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$window.ShowDialog()

#endregion

#region add action

#region code reused
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window">
    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        
        <TextBox x:Name = "PathTextBox"
            Width="150"
            Grid.Column="0"
            Grid.Row="0"
        />
        <Button x:Name = "ValidateButton"
            Content="Validate"
            Grid.Column="1"
            Grid.Row="0"
        />
        <Button x:Name = "RemoveButton"
            Content="Remove"
            Grid.Column="0"
            Grid.Row="1"
        />
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
#endregion

$validateButton = $window.FindName("ValidateButton")
$removeButton = $window.FindName("RemoveButton")
$pathTextBox = $window.FindName("PathTextBox")

$ValidateButton.Add_Click({
    If(-not (Test-Path $pathTextBox.Text)){
        $pathTextBox.Text = ""
    }
})

$removeButton.Add_Click({
    If($pathTextBox.Text){
        If(Test-Path $pathTextBox.Text){
            Remove-Item $pathTextBox.Text
        }
    }
})

$window.ShowDialog()

#endregion

#region final touches
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window"
    Title="Folder Window"
    SizeToContent="WidthAndHeight" >
    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="23"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        
        <TextBox x:Name = "PathTextBox"
            Width="150"
            Margin="10"
            Grid.Column="0"
            Grid.Row="0"
        />
        <Button x:Name = "ValidateButton"
            Content="Validate"
            Width="50"
            Margin="10"
            Grid.Column="1"
            Grid.Row="0"
        />
        <Button x:Name = "RemoveButton"
            Content="Remove"
            Width="50"
            Margin="10"
            Grid.Column="0"
            Grid.Row="1"
        />
        <StackPanel
            Orientation="Horizontal"
            Grid.Column="0"
            Grid.Row="3"
            Grid.ColumnSpan="2"
            HorizontalAlignment="Center"
        >
            <Button x:Name = "OkButton"
                IsDefault="True"
                Content="OK"
                Width="50"
                Margin="10"
            />
            <Button x:Name = "CancelButton"
                IsCancel="True"
                Content="Cancel"
                Width="50"
                Margin="10"
            />
        </StackPanel>
    </Grid>
</Window>
"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$validateButton = $window.FindName("ValidateButton")
$removeButton = $window.FindName("RemoveButton")
$pathTextBox = $window.FindName("PathTextBox")

$ValidateButton.Add_Click({
    If(-not (Test-Path $pathTextBox.Text)){
        $pathTextBox.Text = ""
    }
})

$removeButton.Add_Click({
    If($pathTextBox.Text){
        If(Test-Path $pathTextBox.Text){
            Remove-Item $pathTextBox.Text
        }
    }
})

$window.ShowDialog()
#endregion
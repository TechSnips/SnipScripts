#Add the WPF type
Add-Type -AssemblyName PresentationFramework

#region XAML
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window"
    Title="User Management WPF"
    SizeToContent="WidthAndHeight" >

    <Grid x:Name="Grid">
        <Grid.RowDefinitions>
            <RowDefinition Height="23"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="23"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="23"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="23"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="23"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="50"/>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="20"/>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="50"/>
        </Grid.ColumnDefinitions>
        
        <Label x:Name = "UsernameLabel"
            Content = "Username"
            Grid.Column = "1"
            Grid.Row = "1"
        />

        <TextBox x:Name = "UserNameTextBox"
            Width = "100"
            Grid.Column = "1"
            Grid.Row = "2"
        />
        <Button x:Name = "SearchButton"
            Content = "Search"
            Grid.Column = "3"
            Grid.Row = "2"
        />
        <Label x:Name = "FirstNameLabel"
            Content = "First Name"
            Grid.Column = "1"
            Grid.Row = "4"
        />
        <Label x:Name = "LastNameLabel"
            Content = "Last Name"
            Grid.Column = "3"
            Grid.Row = "4"
        />
        <TextBox x:Name = "FirstNameTextBox"
            Width = "100"
            Grid.Column = "1"
            Grid.Row = "5"
        />
        <TextBox x:Name = "LastNameTextBox"
            Width = "100"
            Grid.Column = "3"
            Grid.Row = "5"
        />
        <Label x:Name = "TitleLabel"
            Content = "Title"
            Grid.Column = "1"
            Grid.Row = "7"
        />
        <Label x:Name = "ManagerLabel"
            Content = "Manager"
            Grid.Column = "3"
            Grid.Row = "7"
        />
        <TextBox x:Name = "TitleTextBox"
            Width = "100"
            Grid.Column = "1"
            Grid.Row = "8"
        />
        <TextBox x:Name = "ManagerTextBox"
            Width = "100"
            Grid.Column = "3"
            Grid.Row = "8"
        />
        <Button x:Name = "SetButton"
            Content = "Set"
            Grid.Column = "3"
            Grid.Row = "10"
        />
    </Grid>
</Window>
"@
#endregion

#region Variables

#Collect the xaml
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#Grab tho controls into variables
$UserNameTB = $window.FindName("UserNameTextBox")
$FirstNameTB = $window.FindName("FirstNameTextBox")
$LastNameTB = $window.FindName("LastNameTextBox")
$TitleTB = $window.FindName("TitleTextBox")
$ManagerTB = $window.FindName("ManagerTextBox")
$SearchButton = $window.FindName("SearchButton")
$SetButton = $window.FindName("SetButton")

#endregion

#region Control the focus

#Set the search button as default when in the username text box
$UserNameTB.Add_GotFocus({
    $SetButton.IsDefault = $false
    $SearchButton.IsDefault = $true
})

#Set the set button as default when in the attribute text boxes
$FirstNameTB.Add_GotFocus({
    $SetButton.IsDefault = $true
    $SearchButton.IsDefault = $false
})
$LastNameTB.Add_GotFocus({
    $SetButton.IsDefault = $true
    $SearchButton.IsDefault = $false
})
$TitleTB.Add_GotFocus({
    $SetButton.IsDefault = $true
    $SearchButton.IsDefault = $false
})
$ManagerTB.Add_GotFocus({
    $SetButton.IsDefault = $true
    $SearchButton.IsDefault = $false
})

#endregion

#region Clicks

#Find the user when the search button is pressed
$SearchButton.Add_Click({
    $user = $null
    $user = Get-ADUser -Identity $UserNameTB.Text -Properties Title,Manager
    If($user){
        $FirstNameTB.Text = $user.GivenName
        $LastNameTB.Text = $user.SurName
        $TitleTB.Text = $user.Title
        If($user.Manager){
            $managerTB.Text = (Get-ADUser $user.Manager).SamAccountName
        }Else{
            $managerTB.Text = ""
        }
    }Else{
        $FirstNameTB.Text = $LastNameTB.Text = $TitleTB.Text = $managerTB.Text = ""
    }
})

#Set the user attributes when the set button is pressed
$SetButton.Add_Click({
    $user = Get-ADUser $UserNameTB.Text
    If($user){
        $UserSplat = @{
            Identity = $user.SamAccountName
            GivenName = If($FirstNameTB.Text){$FirstNameTB.Text}Else{$null}
            SurName = If($LastNameTB.Text){$LastNameTB.Text}Else{$null}
            Title = If($TitleTB.Text){$TitleTB.Text}Else{$null}
            Manager = If($ManagerTB.Text){$ManagerTB.Text}Else{$null}
        }
        Set-ADUser @UserSplat
    }Else{
        Write-Host 'No User'
    }
})
#endregion

#Display the dialog
$window.ShowDialog()
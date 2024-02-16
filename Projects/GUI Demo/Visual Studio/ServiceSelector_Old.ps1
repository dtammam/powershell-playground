# Documentation https://learn.microsoft.com/en-us/dotnet/api/system.windows.controls?view=windowsdesktop-7.0

# Import type for WPF
Add-Type -AssemblyName PresentationFramework

# Import our xaml file
$xamlFile = "C:\PowerShell-Scripts\GUI Demo\Visual Studio\MainWindow.xaml"
$inputXaml = Get-Content -Path $xamlFile -Raw

# Make modified requirements to the xaml file for usage in PowerShell context
$inputXaml = $inputXaml`
-replace 'mc:Ignorable="d"',''`
-replace "x:N","N"`
-replace '^<Win.*','<Window'

# Create a XAML variable for ongoing usage
[XML]$xaml = $inputXaml

# Create a reader 
$reader = New-Object System.Xml.XmlNodeReader $xaml
try {
    # Load the xaml leveraging our reader
    $psForm = [Windows.Markup.XamlReader]::Load($reader)
}
catch {
    Write-Verbose $PSItem.Exception
    throw
}

$Xaml.SelectNodes(("//*[@Name]")) | ForEach-Object {
    try {
        Set-Variable -Name "var_$($PSItem.Name)" -Value $psForm.FindName($PSItem.Name) -ErrorAction Stop
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
}

# Review all variables loaded with our specified prefix
Get-Variable var_*

# Functionality of the code
Get-Service | ForEach-Object {$var_dropDownService.Items.Add($PSItem.Name)}

Function Get-ServiceDetails {
    $serviceName = $var_dropDownService.SelectedItem
    $serviceDetails = Get-Service $serviceName | select *

    $var_labelServiceName.Content = $serviceDetails.displayname
    $var_labelServiceState.Content = $serviceDetails.status

    $var_labelServiceName.Content

    if ($var_labelServiceState.Content -eq 'Running') {
        $var_labelServiceState.Foreground = '#00ff00'
    }
    else {
        $var_labelServiceState.Foreground = '#ff0000'
    }
}
#endregion

# Control to use for the selection and event (https://learn.microsoft.com/en-us/dotnet/api/system.windows.controls.combobox.onselectionchanged?view=windowsdesktop-7.0#system-windows-controls-combobox-onselectionchanged(system-windows-controls-selectionchangedeventargs)
$var_dropDownService.Add_SelectionChanged({Get-ServiceDetails})

# Display the imported form
$psForm.ShowDialog()
<#
.SYNOPSIS
    A PowerShell script to display a GUI form for reviewing Windows services.

.DESCRIPTION
    A PowerShell script that uses WPF to create a GUI form for displaying information about Windows services.
    The script imports a XAML file and displays a form with a dropdown menu containing service names.
    Upon selecting a service, it displays the service's display name and status.
    Information on element controls can be found here: https://learn.microsoft.com/en-us/dotnet/api/system.windows.controls?view=windowsdesktop-7.0

.EXAMPLE
    .\WindowsServicesGUI.ps1
#>

# --- Variables and Constants ---

#region Variables and Constants
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
        throw "Unable to set variables."
    }
}

# Review all variables loaded with our specified prefix
Get-Variable var_*

# Functionality of the code
Get-Service | ForEach-Object {$var_dropDownService.Items.Add($PSItem.Name)}
#endregion

# --- Functions ---

#region Functions
<#
.SYNOPSIS
    Retrieves and displays the details of a selected Windows service.

.DESCRIPTION
    The Get-ServiceDetails function retrieves the details of the selected service from the dropdown menu
    and updates the display name and status on the form. The status label text color is updated based on
    whether the service is running or not (green for running, red for stopped or other states).

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Get-ServiceDetails

.NOTES
    This function is intended to be used as an event handler for the dropdown menu in the script's GUI form.
#>
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

# --- Main Execution ---

#region Main Execution
# Control to use for the selection and event: https://learn.microsoft.com/en-us/dotnet/api/system.windows.controls.combobox.onselectionchanged?view=windowsdesktop-7.0#system-windows-controls-combobox-onselectionchanged(system-windows-controls-selectionchangedeventargs
$var_dropDownService.Add_SelectionChanged({Get-ServiceDetails})

# Display the imported form
$psForm.ShowDialog()
#endregion
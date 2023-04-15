<#
.SYNOPSIS
    A program that allows one to see a service's current state.

.DESCRIPTION
    A program that allows one to see a service's current state and friendly name by selecting it in a drop-down menu.

.EXAMPLE
    .\Serviceselector2.ps1
#>

# --- Variables and Constants ---

#region Variables and Constants
# Import Windows form assembly
Add-Type -AssemblyName System.Windows.Forms

# Create reusable variables for easily creating new forms and labels
$formObject = [System.Windows.Forms.Form]
$labelObject = [System.Windows.Forms.Label]
$comboBoxObject = [System.Windows.Forms.ComboBox]
$defaultFont = 'Verdana,12'
#endregion

# --- Functions ---

#region Functions
Function Get-ServiceDetails {
    $serviceName = $dropDownService.SelectedItem
    $serviceDetails = Get-Service $serviceName | select *

    $labelServiceName.Text = $serviceDetails.displayname
    $labelServiceState.Text = $serviceDetails.status

    if ($labelServiceState.Text -eq 'Running') {
        $labelServiceState.ForeColor = '#00ff00'
    }
    else {
        $labelServiceState.ForeColor = '#ff0000'
    }
}
#endregion

# --- Main Execution ---

#region Main Execution
# Create and configure the main form
$appForm = New-Object $formObject
$appForm.ClientSize = '500,300'
$appForm.Text = 'Dean Tammam - Service Inspector'
$appForm.BackColor = '#ffffff'
$appForm.Font = $defaultFont

# --- Define UI elements ---

    # Services label
    $labelService = New-Object $labelObject
    $labelService.Text = 'Services:'
    $labelService.AutoSize = $true
    $labelService.Location = New-Object System.Drawing.Point(20,20)

    # Services dropdown
    $dropDownService = New-Object $comboBoxObject
    $dropDownService.Width = '300'
    $dropDownService.Location = New-Object System.Drawing.Point(150,20)
    $dropDownService.Text = 'Pick a service...'

    # Service Friendly Name label
    $labelServiceForName = New-Object $labelObject
    $labelServiceForName.Text = 'Service Friendly Name:'
    $labelServiceForName.AutoSize = $true
    $labelServiceForName.Location = New-Object System.Drawing.Point(20,60)

    # Service Friendly Name display label
    $labelServiceName = New-Object $labelObject
    $labelServiceName.Text = ''
    $labelServiceName.AutoSize = $true
    $labelServiceName.Location = New-Object System.Drawing.Point(240,60)

    # Service Status label
    $labelServiceForState = New-Object $labelObject
    $labelServiceForState.Text = 'Service Status:'
    $labelServiceForState.AutoSize = $true
    $labelServiceForState.Location = New-Object System.Drawing.Point(20,90)

    # Service Status display label
    $labelServiceState = New-Object $labelObject
    $labelServiceState.Text = ''
    $labelServiceState.AutoSize = $true
    $labelServiceState.Location = New-Object System.Drawing.Point(240,90)

# Populate the dropdown list of services
Get-Service | ForEach-Object {$dropDownService.Items.Add($PSItem.Name)}

# Attach event handlers
$dropDownService.Add_SelectedIndexChanged({Get-ServiceDetails})

# Add items to the form
$appForm.Controls.AddRange(@($labelService, $dropDownService, $labelServiceForName, $labelServiceName, $labelServiceForState, $labelServiceState))

# Display the window and dispose of it when closed

$appForm.ShowDialog()
$appForm.Dispose()
#endregion
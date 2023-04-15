# Import Windows form assembly
Add-Type -AssemblyName System.Windows.Forms

# Create reusable variables for easily creating new forms and labels
$formObject = [System.Windows.Forms.Form] #A Window that will pop-up
$labelObject = [System.Windows.Forms.Label] #Simply a label to put text in
$comboBoxObject = [System.Windows.Forms.ComboBox] #A dropdown to use
$defaultFont = 'Verdana,12' #Standard variable for font that can be used elsewhere

# Create our form and define properties of the form
$appForm = New-Object $formObject
$appForm.ClientSize = '500,300'
$appForm.Text = 'Dean Tammam - Service Inspector'
$appForm.BackColor = '#ffffff'
$appForm.Font = $defaultFont # Applies to all entries on the form

### Build the labels
$labelService = New-Object $labelObject
$labelService.Text = 'Services:'
$labelService.AutoSize = $true
$labelService.Location = New-Object System.Drawing.Point(20,20)

### Build the dropdown
$dropDownService = New-Object $comboBoxObject
$dropDownService.Width = '300'
$dropDownService.Location = New-Object System.Drawing.Point(150,20) #Same Y-level as the label, but a different X
$dropDownService.Text = 'Pick a service...'

### Populate the dropdown list of services
Get-Service | ForEach-Object {$dropDownService.Items.Add($PSItem.Name)}

### Build the label for friendly name
$labelServiceForName = New-Object $labelObject
$labelServiceForName.Text = 'Service Friendly Name:'
$labelServiceForName.AutoSize = $true
$labelServiceForName.Location = New-Object System.Drawing.Point(20,60)

### Build the label for actually displaying friendly name
$labelServiceName = New-Object $labelObject
$labelServiceName.Text = ''
$labelServiceName.AutoSize = $true
$labelServiceName.Location = New-Object System.Drawing.Point(240,60)

### Build the label for service state
$labelServiceForState = New-Object $labelObject
$labelServiceForState.Text = 'Service Status:'
$labelServiceForState.AutoSize = $true
$labelServiceForState.Location = New-Object System.Drawing.Point(20,90)

### Build the label for actually displaying the service state
$labelServiceState = New-Object $labelObject
$labelServiceState.Text = ''
$labelServiceState.AutoSize = $true
$labelServiceState.Location = New-Object System.Drawing.Point(240,90)

### Logic section/functions
Function Get-ServiceDetails {
    # Populates friendly name
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
# Add the functions to the form
$dropDownService.Add_SelectedIndexChanged({Get-ServiceDetails})#Add_SelectedIndexChanged isn't visible... check C# documentation

# Add items to the form
$appForm.Controls.AddRange(@($labelService,$dropDownService,$labelServiceForName,$labelServiceName,$labelServiceForState,$labelServiceState))

# Display the form
$appForm.ShowDialog()

# Cleans up the form
$appForm.Dispose()
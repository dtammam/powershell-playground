<#
.SYNOPSIS
    A simple Hello World program with a button to toggle the display of the text.

.DESCRIPTION
    A program that displays a Hello World text and a button that toggles the display of the text.
#>

# --- Variables and Constants ---

#region Variables and Constants
# Import Windows form assembly
Add-Type -AssemblyName System.Windows.Forms

# Create reusable variables for easily creating new forms and labels
$formObject = [System.Windows.Forms.Form]
$labelObject = [System.Windows.Forms.Label]
$buttonObject = [System.Windows.Forms.Button]
#endregion

# --- Functions ---

#region Functions
Function Say-Hello {
    # Toggles the display of the Hello World text on button click
    if ($helloWorldLabelTitle.Text -eq '') {
        $helloWorldLabelTitle.Text = "Hello world!"
    }
    else {
        $helloWorldLabelTitle.Text = ''
    }
}
#endregion

# --- Main Execution ---

#region Main Execution
# Create and configure the main form
$helloWorldForm = New-Object $formObject
$helloWorldForm.ClientSize = '500,300'
$helloWorldForm.Text = 'Hello World - Tutorial'
$helloWorldForm.BackColor = '#ffffff'

# --- Define UI elements ---

# Hello World label
$helloWorldLabelTitle = New-Object $labelObject
$helloWorldLabelTitle.Text = ''
$helloWorldLabelTitle.AutoSize = $true
$helloWorldLabelTitle.Font = 'Verdana,24,style=Bold'
$helloWorldLabelTitle.ForeColor = 'red'
$helloWorldLabelTitle.Location = New-Object System.Drawing.Point(133,110)

# Say hello button
$buttonHelloWorld = New-Object $buttonObject
$buttonHelloWorld.Text = 'Say hello!'
$buttonHelloWorld.AutoSize = $true
$buttonHelloWorld.Location = New-Object System.Drawing.Point(210,190)

# Attach event handlers
$buttonHelloWorld.Add_Click({Say-Hello})

# Add items to the form
$helloWorldForm.Controls.AddRange(@($helloWorldLabelTitle, $buttonHelloWorld))

# Display the window and dispose of it when closed
$helloWorldForm.ShowDialog()
$helloWorldForm.Dispose()
#endregion
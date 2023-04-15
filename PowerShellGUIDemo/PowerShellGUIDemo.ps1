# Import Windows form assembly
Add-Type -AssemblyName System.Windows.Forms

# Create reusable variables for easily creating new forms and labels
$formObject = [System.Windows.Forms.Form] #A Window that will pop-up
$labelObject = [System.Windows.Forms.Label] #Simply a label to put text in
$buttonObject = [System.Windows.Forms.Button] #A button to use for interacting

# Create our form and define properties of the form
$helloWorldForm = New-Object $formObject
$helloWorldForm.ClientSize = '500,300' #Coordinates to size window
$helloWorldForm.Text = 'Hello World - Tutorial' #Window label
$helloWorldForm.BackColor = '#ffffff' #White background for the background

$helloWorldLabelTitle = New-Object $labelObject
$helloWorldLabelTitle.Text = 'Hello world!' #Text to display
$helloWorldLabelTitle.AutoSize = $true #Can it autosize?
$helloWorldLabelTitle.Font = 'Verdana,24,style=Bold' #Font,size,style=type
$helloWorldLabelTitle.ForeColor='red'
$helloWorldLabelTitle.Location = New-Object System.Drawing.Point(100,110) #Coordinates of the label

$buttonHelloWorld = New-Object $buttonObject
$buttonHelloWorld.Text = 'Say hello!' #Button text
$buttonHelloWorld.AutoSize = $true #Can it autosize?
$buttonHelloWorld.Location = New-Object System.Drawing.Point(210,190) #Coordinates of button

# Add elements to the form as control elements
$helloWorldForm.Controls.AddRange(@($helloWorldLabelTitle,$buttonHelloWorld))

### Logic section/functions
Function Say-Hello {
    # Basically allows the text to be removed and readded with a button click
    if ($helloWorldLabelTitle.Text -eq '') {
        $helloWorldLabelTitle.Text = "Hello world!"
    }
    else {
        $helloWorldLabelTitle.Text = ''
    }
}
# Add the functions to the form
$buttonHelloWorld.Add_Click({Say-Hello})#Add_Click isn't visible... check C# documentation

# Display the form
$helloWorldForm.ShowDialog()

# Cleans up the form
$helloWorldForm.Dispose()
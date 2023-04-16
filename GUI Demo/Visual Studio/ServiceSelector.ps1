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

# Display the imported form
$psForm.ShowDialog()
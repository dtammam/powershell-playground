
function Get-JsonFileContent {
    <#
    .SYNOPSIS
        Reads a JSON file from the specified path and converts its content into a PowerShell object.
    .DESCRIPTION
        The Get-JsonFileContent function takes the file path of a JSON file as input, reads the entire content of the file,
        and converts it into a PowerShell object using ConvertFrom-Json. If the specified file does not exist or cannot be
        parsed, the function writes an error message and returns $null.
    .PARAMETER FilePath
        The full path to the JSON file that needs to be read and converted into a PowerShell object.
    .OUTPUTS
        [PSCustomObject] - The PowerShell object representing the JSON content.
        Returns $null if the file does not exist or if there is an error during JSON conversion.
    .EXAMPLE
        $config = Get-JsonFileContent -FilePath "C:\Configs\settings.json"
        if ($config) { # Proceed with using the $config object }
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$FilePath
    )

    if (-not (Test-Path $FilePath)) {
        Write-Error "The file at path [$($FilePath)] does not exist."
        return $null
    }

    try {
        $jsonContent = Get-Content -Path $FilePath -Raw
        $jsonObject = $jsonContent | ConvertFrom-Json
        return $jsonObject
    } catch {
        Write-Error "Failed to parse .json with the following exception: [$($_.Exception.Message)]"
        return $null
    }
}

function Show-Properties {
    <#
    .SYNOPSIS
        Displays the properties of a specified PSCustomObject.
    .DESCRIPTION
        The Show-Properties function takes a PSCustomObject as input and outputs specified properties.
        This is a test function meant to allow one to see how to intake JSON and manual objects for the same output.
    .PARAMETER configProperties
        The PSCustomObject containing the properties 'Name', 'Product', and 'Path' that need to be displayed.
    .EXAMPLE
        $properties = [pscustomobject]@{
            Name    = 'Awesomesauce'
            Product = 'Awesome IDE'
            Path    = 'C:\Program Files\Awesomesauce'
        }
        Show-Properties -configProperties $properties
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$configProperties
    )

    Write-Output "Welcome to the Show-Properties function.`n"

    if ($null -ne $configProperties) {
        Write-Output "Input received within custom object. Proceeding..."
        Write-Output "Name property is [$($configProperties.Name)]"
        Write-Output "Product property is [$($configProperties.Product)]"
        Write-Output "Path property is [$($configProperties.Path)]"
        Write-Output "`nProcessing of properties has been completed."
    } else {
        Write-Output "Custom input missing from property. Exiting."
    }
}

# # Option 1: Manual Input
# # This block shows how you can manually define properties using a PSCustomObject
# $properties = [pscustomobject]@{
#     Name    = 'Awesomesauce'
#     Product = 'Awesome IDE'
#     Path = 'C:\Program Files\Awesomesauce'
# }

# Option 2: Input from JSON
# This block demonstrates loading properties from a JSON file located in the same directory as the script
$configFilePath = "$PSScriptRoot\Config.json"
$properties = Get-JsonFileContent -FilePath $configFilePath
# (Optional) Consider sanitizing or adjusting the path if needed, though PowerShell generally handles double backslashes well.
# $properties.Path = $properties.Path -replace '\\', '\\'

# If we have a valid PSCustomObject, then we can call the Show-Properties function
if ($properties) {
    Write-Output "Successfully retrieved properties from JSON file."
    Show-Properties -ConfigProperties $properties
} else {
    Write-Error "Failed to load configuration. Exiting."
}
param (
    [Parameter(Mandatory=$false)]
    [string]$ConfigFile
)

# If no custom config file is provided, use the default one in the script's directory
if (-not $ConfigFile) { $ConfigFile = Join-Path -Path $PSScriptRoot -ChildPath 'DosGameSettings.json' }

# Debugging to see what ConfigFile resolves to
Write-Host "Using config file: [$ConfigFile]"

function Get-JsonFileContent {
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

$dosGameProperties = Get-JsonFileContent -FilePath $ConfigFile

if ($dosGameProperties) {
    # Do something with $dosGameProperties here
    Write-Host "Config successfully loaded."
} else {
    Write-Error "Failed to load the configuration from $ConfigFile."
}

function Invoke-DOSGame {
    <#
    .SYNOPSIS
        Launch a DOS game leveraging Dosbox programmatically.
    .DESCRIPTION
        Launch a DOS game by providing the full path to the game executable.
        No need to worry about configuring the game or running manually each time with a modern shortcut!
    .PARAM DosboxPath
        Path to the Doxbox executable.
        Non-mandatory parameter, the default 32-bit version path is pre-populated.
    .PARAM GameExecutablePath
        Full path to the game executable file.
    .NOTES
        DosBox is a prerequisite app that needs to be installed for this to work.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$DosboxPath = "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe",
        [Parameter(Mandatory)]
        [string]$GameExecutablePath
    )

    $gamePath = Split-Path $GameExecutablePath -Parent
    $gameExecutable = Split-Path $GameExecutablePath -Leaf

    Start-Process $DosboxPath -ArgumentList "-c `"mount C $gamePath`" -c `"C:`" -c `"$gameExecutable`" -c `"exit`""
}

function Invoke-Main {
    <#
    .SYNOPSIS
        Main function to run the script.
    .DESCRIPTION
        This function checks if the configuration file exists before attempting to load it.
        If the configuration file exists, it will call the Invoke-DosGame function with the DosboxPath and GameExecutablePath.
    .NOTES
        This is the entry point of the script.
    #>
    
    # Check if the configuration file exists before attempting to load it
    $dosGameProperties = Get-JsonFileContent -FilePath $ConfigFile

    if ($dosGameProperties) { 
        Invoke-DosGame -DosboxPath $dosGameProperties.DosboxPath -GameExecutablePath $dosGameProperties.GameExecutablePath  
    } else {
        Write-Error "Failed to load the configuration from $ConfigFile."
    }
}

Invoke-Main
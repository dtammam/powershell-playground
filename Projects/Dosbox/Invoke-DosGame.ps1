param (
    [Parameter(Mandatory=$false)]
    [string]$DosboxPath = "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe",
    [Parameter(Mandatory)]
    [string]$GameExecutablePath
)

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
        [Parameter(Mandatory)]
        [string]$DosboxPath,
        [Parameter(Mandatory)]
        [string]$GameExecutablePath
    )

    $gamePath = Split-Path $GameExecutablePath -Parent
    $gameExecutable = Split-Path $GameExecutablePath -Leaf

    Start-Process $DosboxPath -ArgumentList "-c `"mount C $gamePath`" -c `"C:`" -c `"$gameExecutable`" -c `"exit`""
}

Invoke-DosGame -DosboxPath $DosboxPath -GameExecutablePath $GameExecutablePath
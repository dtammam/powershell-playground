<#
WriteLog.ps1

    Goal:
        The purpose of this module is to allow clean and consistent logging when running PowerShell scripts.

    Audience:
        The audience would be technologists looking for more functional log standardization as they write and execute scripts.

    Version:
        8/6/2022 - Original version

    Return Codes:
        N/A

    References:
        N/A
#>

# Global variables for various logging functions
$LogFolderPath = "C:\Program Files\_ScriptLogs"
$LogFilePath = "$($LogFolderPath)\$($ScriptName).log"
$Global:LogTailPath = "$($LogFolderPath)\$($ScriptName)_Transcript.log"

# Create our log directory if it doesn't exist
if (!(Test-Path -Path $LogFolderPath)) {
    New-Item -ItemType Directory -Force -Path $LogFolderPath
}

function Write-Log($Message) {

<#
    .SYNOPSIS 
    Writes to a log file in an efficient way, naming it after the script and empowering you to use a similarly-formatted transcript file.

    .DESCRIPTION
    Adds a date and grabs the most recent message, appends it to the global event message and outputs it as a string within the log file itself.

    .PARAMETER $Message
    The log you'd want written in the event.

    .INPUTS
    This function does not support piping.

    .OUTPUTS
    Returns a written log.

    .EXAMPLE
    Write-Log "Script failed with the following exception: $($_)"

    .LINK
    N/A
#>
    Add-Content $LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Global:EventMessage += $Message | Out-String
}
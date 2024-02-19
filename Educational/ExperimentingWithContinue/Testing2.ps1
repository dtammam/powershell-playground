function Write-Log {
<#
.SYNOPSIS
    This script writes log messages to file and outputs them.

.DESCRIPTION
    The Write-Log function writes a given message to both an output stream and a log file specified by the global variable `$logFilePath`. It also accumulates all logged events in the global variable `$event_msg`.

.PARAMETER Message
    [string] - Mandatory parameter specifying the message that you wish to be written to the log or output stream. 

.EXAMPLE
    Write-Log -Message "This is a test message"

.NOTES
    The function assumes that `$logFilePath` variable has been set already, which stores the path where logs should be stored. If it's not set, you need to use Set-Variable cmdlet to set it first. For instance: 
    $script:logFilePath = "C:\Logs\MyScriptLog.txt"
  
    The `$event_msg` variable is a global variable that holds all logged events concatenated as strings. It's automatically updated during execution of the function. You can access it later to view or analyze what was written into log file.
#>
    [CmdletBinding()]  # Required for using verbose, debug, etc. options
    param(
        [Parameter(Mandatory=$true)]
        [string] $Message
    )

    begin {}

    process{
        Add-Content -Path $logFilePath -Value "$(Get-Date) - $Message"
        Write-Output $Message
        $global:event_msg += $Message | Out-String
    }

    end{}
}
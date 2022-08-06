<#
WriteEvent.ps1

    Goal:
        The purpose of this module is to allow clean and consistent event logging when running PowerShell scripts.

    Audience:
        The audience would be technologists looking for simple event logging as they write and execute scripts.

    Version:
        8/6/2022 - Original version

    Return Codes:
        N/A

    References:
        N/A
#>

# Global variables for various event functions
$Global:EventMessage = ''
$Global:EventLogName = 'Application'
$Global:EventSource = "$($Global:ScriptName)"

New-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -MessageResourceFile 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\EventLogMessages.dll' -ErrorAction SilentlyContinue

function Write-Event($EventID, $Message) {

 <#
    .SYNOPSIS 
    Writes to an Event Log in a more terse way than the standard Write-EventLog function.

    .DESCRIPTION
    This function uses the Write-EventLog function but already has most common parameters accounted for.

    .PARAMETER $EventID
    The EventID that you'd want the log written with.

    .PARAMETER $Message
    The log you'd want written in the event.

    .INPUTS
    This function does not support piping.

    .OUTPUTS
    Returns a written event log.

    .EXAMPLE
    Write-Event -EventId $Global:SuccessEventID -Message $($Global:EventMessage | Out-String)

    .LINK
    N/A
#>

    Return Write-EventLog -LogName $EventLogName -Source $Global:EventSource -EntryType Information -EventId $EventID -Message $Message
}

<# Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventId $Global:EventID -Message $($Global:EventMessage | Out-String)
#>
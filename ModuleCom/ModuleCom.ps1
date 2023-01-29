<#
ModuleCom.ps1

    Goal:
        Helps practice using a module. Inspired by a 90's website that never ends, 'Welcome... you can do anything!'
        This script explains what it does, which is everything :) effectively, it is a proof of concept for custom modules, a module manifest and awesome PowerShell capabilities to save the need to write code multiple times.

    Audience:
        PowerShell scripters who want to leverage modules.

    Version:
        8/6/2022 - Original version

    Exit Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Script-specific global variables for logging/events/exiting with declared exit codes
$Global:ScriptName = $MyInvocation.MyCommand
$Global:SuccessEventID = '601'
$Global:FailureEventID = '603'
$Global:SuccessExitCode = '0'
$Global:FailureExitCode = '1'

# Import functions from common utilities module, removing it first in case anything is sitting in memory
Remove-Module -Name CommonUtilities -ErrorAction SilentlyContinue
#Import-Module -Name "$($PSScriptRoot)\CommonUtilities" -Force
Import-Module -Name "$($PSScriptRoot)\Write-Log" -Force
# Now that it's imported, get the cmdlets out of the module
#Get-Command -Module CommonUtilities
Get-Command -Module Write-Log

# Overarching Try block for execution
try {
    # Begin a tail for logging non-implicitly captured events from the terminal
    Start-Transcript -Path $Global:LogTailPath -Append

    # Main execution logic
    # Notice that the Write-Log function is not defined in the script... the module has it!
    Write-Log "This script loaded a PowerShell Module manifest, is using one to write this log right now!"
    Write-Log "You can try 'Get-Help Write-Log' or 'Get-Help Write-Event if you'd like! I'm going to beep now."
    [System.Console]::Beep(500,300)
    Start-Sleep -Seconds 1.5
    Write-Log "Once I'm finished... check the Event Viewer for the 'ModuleCom' event in Application logs. Also 'C:\Program Files\_ScriptLogs'. Goodbye!"
    # Notice that the Write-Event function is not defined in the script... the module has it too!
    Write-Event -EventId $Global:SuccessEventID -Message $($Global:EventMessage | Out-String)

    # Cleanup and exit script
    Stop-Transcript
    Exit $Global:SuccessExitCode
}

catch {
    # Cleanup and exit script
    Write-Log "Script failed with the following exception: $($_)"
    Write-Event -EventId $Global:FailureEventID -Message $($Global:EventMessage | Out-String)
    Stop-Transcript
    Exit $Global:FailureExitCode
}

<#PSScriptInfo

.VERSION 1.0

.AUTHOR Dean Tammam

.TAGS CleanCodeTemplate

.RELEASENOTES
Version 1.0: 8/17/2022 - Original version
#>

<#
.SYNOPSIS
    The purpose of this script is to provide a baseline template for future projects.
.DESCRIPTION
    The audience is PowerShell programmers looking to create and maintain clean code.
.NOTES

#>

Function Open-Header {
    <#
    .SYNOPSIS 
        Prepares global variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
    #>
    $Global:ScriptName = 'CleanCodeTemplate.ps1'
    $ExitCode = '-1'
    $Global:SuccessExitCode = '0'
    $Global:FailureExitCode = '1'
    $Global:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Global:LogFilePath = "$($Global:LogFolderPath)\$($Global:ScriptName).log"
    $Global:LogTailPath = "$($Global:LogFolderPath)\$($Global:ScriptName)_Transcript.log"

    if (!(Test-Path -Path $Global:LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Global:LogFolderPath
    }
}

Function Write-Log($Message) {
    <#
    .SYNOPSIS 
        Writes to a log file.
    .DESCRIPTION
        Writes to a log file. Names it after the script and empowers you to use a similarly-formatted transcript file across your different scripts for reviewing results.
    .PARAMETER $Message
        The log you'd want written in the event.
    .EXAMPLE
        Write-Log "Script failed with the following exception: $($_)"
    #>

    Add-Content $Global:LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Global:EventMessage += $Message | Out-String
}

Function Start-Sound ($Path) {
    <#
    .SYNOPSIS 
        This function plays a sound.
    .DESCRIPTION
        This function plays a sound. Leverages the sound player media component of Windows.
    .PARAMETER Path
        Specifies the file to play.
    #>

    $Sound = New-Object System.Media.SoundPlayer
    $Sound.SoundLocation=$Path
    $Sound.playsync()
}


Try {
    Open-Header
    Start-Transcript -Path $LogTailPath -Append
    Write-Log "$Global:ScriptName: Playing sound..."
    Start-Sound ("C:\Users\dean\source\repos\dtammam\PowerShell-Scripts\CleanCodeTemplate\imsend.wav")
    Write-Log "$Global:ScriptName: Played sound successfully."
    Start-Sound ("C:\Users\dean\source\repos\dtammam\PowerShell-Scripts\CleanCodeTemplate\imsend.wav")
    $ExitCode = $Global:SuccessExitCode
}

Catch {
    Write-Log "$Global:ScriptName: Script failed with the following exception: $_"
    $ExitCode = $Global:FailureExitCode
}

Finally {
    Stop-Transcript
    "Exiting with $ExitCode"
    Exit $ExitCode
}
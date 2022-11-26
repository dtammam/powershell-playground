<#PSScriptInfo

.VERSION 1.0

.AUTHOR Dean Tammam

.TAGS FileSearchWithRegex

.RELEASENOTES
Version 1.0: 11/25/2022 - Original version
#>

<#
.SYNOPSIS
    Selects a list of files based off of a RegEx string.
.DESCRIPTION
    The purpose of this script is to filter through an existing list of files and to parse out desired files 
.NOTES

#>

param (
    [string]$Operator = (Read-Host -Prompt "Input regex type (match or notmatch)"),
    [string]$SearchString = (Read-Host -Prompt "Input string to query for")

)

Function Open-Header {
    <#
    .SYNOPSIS 
        Prepares script variables.
    .DESCRIPTION
        Prepares script variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
    #>
    $Script:ScriptName = 'FileSearchWithRegex.ps1'
    $Script:ExitCode = '-1'
    $Script:EventMessage = ''
    $Script:SuccessExitCode = '0'
    $Script:FailureExitCode = '1'
    $Script:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Script:LogFilePath = "$($Script:LogFolderPath)\$($Script:ScriptName).log"
    $Script:LogTailPath = "$($Script:LogFolderPath)\$($Script:ScriptName)_Transcript.log"

    if (!(Test-Path -Path $Script:LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Script:LogFolderPath
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

    Add-Content $Script:LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Global:EventMessage += $Message | Out-String
}

Function Get-Files {
    <#
    .SYNOPSIS 
        Prepares file variables.
    .DESCRIPTION
        Prepares file variables to be parsed throughout the rest of the script.
    #>
    $Script:FileSourceDirectory = 'C:\Apps\Source'
    $Script:FileDestinationDirectory = 'C:\Apps\Destination'
    $Script:FileList = [System.Collections.ArrayList]@()
    $Script:FileQuery = Get-ChildItem -Path $Script:FileSourceDirectory -Recurse
    $Script:QueryCounter = 0
    ForEach ($File in $Script:FileQuery) {
        $FileList.Add($File)
        $Script:QueryCounter += 1
    }
}

Function Get-FileMatches ($String) {
    <#
    .SYNOPSIS 
        Matches files by name.
    .DESCRIPTION
        Matches files by name using regular expression. Depending on the parameter used when launching the script, the function looks for matching or not matching patterns.
    #>
    $Script:MatchList = [System.Collections.ArrayList]@()
    $Script:MatchCounter = 0

    If ($Operator -eq 'match') {
        ForEach ($File in $Script:FileQuery) {
            If ($File -match $String) {
                Write-Log "$File $Operator $String"
                $MatchList.Add($File)
            }
        }
    }

    ElseIf ($Operator -eq 'notmatch') {
        ForEach ($File in $Script:FileQuery) {
            If ($File -notmatch $String) {
                Write-Log "$File $Operator $String"
                $MatchList.Add($File)
            }
        }
    }

    Else {
        "Invalid selection, please attempt to match or notmatch."
    }
}

Try {
    Open-Header
    Start-Transcript -Path $LogTailPath -Append
    Write-Log "$($Script:ScriptName): Opening files..."
    Get-Files
    Write-Log "Opened files. Processing files..."
    Get-FileMatches "$SearchString"
    ForEach ($Item in $MatchList) {
        Copy-Item -Path $Script:FileSourceDirectory\$Item -Destination $Script:FileDestinationDirectory\$Item
        Write-Log "Copied $Script:FileSourceDirectory\$Item to $Script:FileDestinationDirectory\$Item"
        $Script:MatchCounter += 1
    }
    Write-Log "Total source files: $Script:QueryCounter"
    Write-Log "Total processed files: $Script:MatchCounter"
    Write-Log "Script complete."
    $Script:ExitCode = $Script:SuccessExitCode
}

Catch {
    Write-Log "Script failed with the following exception: $_"
    $Script:ExitCode = $Script:FailureExitCode
}

Finally {
    Stop-Transcript
    Exit $Script:ExitCode
}
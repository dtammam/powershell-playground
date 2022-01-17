<#
WriteLog.ps1

    Goal: 
        The purpose of this module is to allow clean and consistent logging when running PowerShell scripts. 
    Audience:
        The audience would be technologists looking for more functional log standardization as they write and execute scripts.
    Version:
        8/1/2022 - Original version
    Return Codes:
        N/A
    References:
        N/A
#>

# Initialization

    # Global variables for the function.
    $scriptName = $MyInvocation.MyCommand.Name
    $logFolderPath = "C:\Program Files\_scriptLog"
    $logFilePath = "C:\Program Files\_scriptLog\$($scriptName).log"
    $logTailPath ="C:\Program Files\_scriptLog\$($scriptName)_Transcript.log" 

    $eventSource = "ExampleScript"
    $scriptVer = "1.0"
    $serviceName = "TestService"

    # Create our log directory if it doesn't exist.
    if (!(Test-Path -Path $logFolderPath))
        {
            New-Item -ItemType Directory -Force -Path $logFolderPath
        }

    # The write_log function itself.
    function write_log($message)
        {
            Add-Content $logFilePath "$(Get-Date) - $message"
            Write-Output $message
            $global:event_msg += $message | Out-String
        }

# Execution

    # Begin a tail for logging non-implicitly captured events from the terminal.
    Start-Transcript -Path $logTailPath -Append

    # Example code for testing the function.
    write_log "Testing this script. It all looks good!"


Get-H
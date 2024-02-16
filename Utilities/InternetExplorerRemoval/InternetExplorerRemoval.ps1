<#
InternetExplorerRemoval.ps1

    Goal:
        To automate the removal of Internet Explorer from a Windows 10 device.
        It will check and either detect and disable Internet Explorer, or not detect and log that it's already gone.

    Audience:
        Technologists looking to remove Internet Explorer from their Windows 10 devices.

    Version:
        8/6/2022 - Original version

    Return Codes:
        0 - Success
        1 - Failure

    References:
        N/A

    Author:
        Dean Tammam
#>

# Global variables for various logging functions
$Global:EventMessage = ''
$Global:ScriptName = 'InternetExplorerRemoval'
$Global:EventSource = "$($Global:ScriptName)"
$Global:EventLogName = 'Application'
$Global:EventID = '601'
$LogFolderPath = 'C:\Program Files\_ScriptLogs'
$LogFilePath = "C:\Program Files\_ScriptLog\$($Global:ScriptName).log"
$LogTailPath = "C:\Program Files\_ScriptLog\$($Global:ScriptName)_Transcript.log"

# Create our log directory if it doesn't exist, create event
If (!(Test-Path -Path $LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $LogFolderPath
}

New-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -MessageResourceFile 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\EventLogMessages.dll' -ErrorAction SilentlyContinue

# Write-Log function
Function Write-Log($Message) {
    Add-Content $LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Global:EventMessage += $Message | Out-String
}

# Overarching try block for script execution.
Try{
    Start-Transcript -Path $LogTailPath -Append

    # Logic for seeing if Internet Explorer is enabled
    Write-Log "Checking to see if Internet Explorer is installed on $($env:computername)."
    $CheckInternetExplorer = Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -eq 'Internet-Explorer-Optional-amd64'}

    # If it is not disabled, disable it
    If ($CheckInternetExplorer.State -ne 'Disabled') {
        Write-Log 'Initiating uninstall...'
        Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online -NoRestart | Out-Null
        Write-Log 'Uninstalled, reboot required to finalize.'
    }

    # Otherwise, document that it wasn't detected
    Elseif ($CheckInternetExplorer.State -eq 'Disabled') {
        Write-Log 'Internet Explorer already uninstalled.'
    }

    # Cleanup and exit script
    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventId $Global:EventID -Message $($Global:EventMessage | Out-String)
    Stop-Transcript
    Exit 0
}

Catch {
    # Cleanup and exit script
    Write-Log "Script failed with the following exception: $($_)"
    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventId $Global:EventID -Message $($Global:EventMessage | Out-String)
    Stop-Transcript
    Exit 1
}
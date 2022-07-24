<#
ScreenshotCopy.ps1

    Goal:
        The purpose of this script is to copy files that were screenshot and saved in one location to another, due to limitations of the program not allowing one to modify the save location.
        This script will scan the directory for new files, copy the files as-is to the new location, validate that the file exists in the new location, and then delete the original file from the screenshot location.

    Audience:
        Automation-oriented screenshotters. To make useful, update the $RootPath and $DestPath variables.

    Version:
        7/24/2022 - Original version

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Get the name of the current script for file naming/logging - https://www.thomasmaurer.ch/2015/03/get-name-of-the-powershell-script-file-inside-the-script/
#>

# Global variables for various logging functions
$ScriptName = $MyInvocation.MyCommand
$LogFolderPath = "C:\Program Files\_ScriptLogs"
$LogFilePath = "$($LogFolderPath)\$($ScriptName).log"
$LogTailPath = "$($LogFolderPath)\$($ScriptName)_Transcript.log"

# Create our log directory if it doesn't exist
if (!(Test-Path -Path $LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $LogFolderPath
}

# Primary logging function
function Write-Log($Message) {
        Add-Content $LogFilePath "$(Get-Date) - $Message"
        Write-Output $Message
        $Global:EventMessage += $Message | Out-String
    }   

# Overarching Try block for execution
try {
    # Begin a tail for logging non-implicitly captured events from the terminal
    Start-Transcript -Path $LogTailPath -Append

    # Set paths for source folder and destination folder and a counter
    $RootPath = "C:\Root"
    $DestPath = "C:\Dest"
    $Count = 0

    # If the destination folder does not exist... create it
    if (!(Test-Path -Path $DestPath)) {
        New-Item -ItemType Directory -Force -Path $DestPath
    }

    # Find all folders in the root directory
    $FileList = (Get-ChildItem $RootPath -Recurse).FullName

    # For each of these files in the root directory...
    Foreach ($File in $FileList) {
        # Copy to the destination directory
        Copy-Item -Path $File -Destination $DestPath
        Write-Log "Successfully copied $($File) to destination"
        # Now that its' processed... delete it from the root directory
        Remove-Item -Path $File
        Write-Log "Successfully deleted $($File) in root"
        # Update the counter for total files processed at the end
        $Count += 1
    }

    # Note if no files were found/copied and exit
    if ($count -eq 0) {
        Write-Log "No files detected."
        Stop-Transcript
        Exit 0
    }

    # Cleanup and exit script
    Write-Log "Finished copying $($Count) files."
    Stop-Transcript
    Exit 0
}

catch {
    # Cleanup and exit script
    Write-Log "Script failed with the following exception: $($_)"
    Stop-Transcript
    Exit 1
}
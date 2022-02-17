
<#
PhoneNumberSanitizer.ps1

    Goal: 
        Parses through a .csv file and sanitizes phone numbers by removing spaces and special characters then adds +1 to the beginning.
        Simple execution with '-file' and '-newfile' parameters via PowerShell console.
        Requires that the source column containing phone numbers is named 'Phone'.

    Audience:
        For technologists looking to update phone numbers contained in .csv's en masse. 
        If using default execution policies, you'll need to either sign the script or open an Administrative PowerShell terminal in the same directory and run:

            powershell.exe -executionpolicy bypass -File .\PhoneNumberSanitizer.ps1 -file "*yourcsv*.csv" -newfile "*yournewcsv*.csv"

        You can additionally open an Administrative PowerShell terminal in the same directory as this script and run it like so:

            set-executionpolicy bypass
            .\PhoneNumberSanitizer.ps1 -file "sourcefile.csv" -newfile "updatedfile.csv"
            set-executionpolicy default

    Version:
        2/3/2022 - Original version.
        2/4/2022 - Minor comment adjustments to expound on instructions for running the script.
        2/11/2022 - Minor comment adjustments to remove inaccurate notes.
        2/17/2022 - Formatting changes, global variables for all, proper casing, new Event Log capturing.

    Return Codes:
        0 - Success
        1 - Failure

    References:
        For adding the param command-line arguments - https://stackoverflow.com/questions/2157554/how-to-handle-command-line-arguments-in-powershell
        For overwriting the existing column in the table - https://serverfault.com/questions/148339/exporting-specific-fields-with-powershells-export-csv
        For catching any exceptions - https://stackoverflow.com/questions/38419325/catching-full-exception-message

    Author:
        Dean Tammam
        
#>

# ___Param block
Param (
    [String]$File = $(Read-Host "Input source filename that you'd like sanitized, please."),
    [String]$NewFile = $(Read-Host "Input the name of the file you'd want once sanitized, please.")
)

# ___Initialization block

# Global variables
$Global:EventMessage = ''
$Global:ScriptName = 'PhoneNumberSanitizer'
$Global:EventSource = "$($Global:ScriptName)"
$Global:EventLogName = 'Application'
$Global:EventID = '601'

# Error handling variables
$Global:LogFolderPath = 'C:\Program Files\_scriptLog'
$Global:LogFilePath = "C:\Program Files\_scriptLog\$($Global:ScriptName).log"
$Global:LogTailPath = "C:\Program Files\_scriptLog\$($Global:ScriptName)_Transcript.log" 

# Folder and event for error handling.
If (!(Test-Path -Path $Global:LogFolderPath)) {
    new-item -itemtype directory -force -Path $Global:LogFolderPath
}

New-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -MessageResourceFile 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\EventLogMessages.dll' -ErrorAction SilentlyContinue

# Write-Log function
Function Write-Log($Message) {
    Add-Content $Global:LogFilePath "$(Get-Date) - $Message"
    write-output $Message
    $Global:EventMessage += $Message | Out-String
}

# ___Script execution block

# Begin a tail
Start-Transcript -Path $Global:LogTailPath -Append

# Overarching try block
Try {
    # Bring in our source .csv
    $Table = import-csv -Path $File -Delimiter ',' -Encoding Default
    Write-Log "Now processing $($File)!"

    # Process the phone numbers
    Foreach ($Entry in $Table) {
        # Iterate through each of the phone numbers for a given column
        $PhoneNumber = $Entry.Phone
        # RegEx processing to format the numbers how we'd like
        $PhoneUpdate = ($PhoneNumber -Replace "\(0\)", "" -Replace "[^0-9,^+]", "" -Replace "^", "+1")
        Write-Log "Updating $($PhoneNumber) to be $($PhoneUpdate)"
        # Overwrite the existing 'Phone' object in the imported table object with our newly formatted phone number
        Add-Member -InputObject $Entry -MemberType NoteProperty -Name "Phone" -Value $PhoneUpdate -Force
    }

    # Create our new .CSV using all data from imported table object (including our new 'Phone' data)
    $Table | Export-Csv -Path $NewFile -Delimiter ',' -NoTypeInformation
    Write-Log "Newly exported CSV has been created here: $($NewFile)"

    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventId $Global:EventID -Message $($Global:EventMessage | Out-String)
    Stop-Transcript
    Exit 0
}

# Overarching catch block
Catch {
    Write-Log "Script failed with the following exception: $($_)"
    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventId $Global:EventID -Message $($Global:EventMessage | Out-String)
    Stop-Transcript
    Exit 1
}
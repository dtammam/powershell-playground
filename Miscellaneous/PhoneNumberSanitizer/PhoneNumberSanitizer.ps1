
<#
PhoneNumberSanitizer.ps1

    Goal: 
        Parses through a .csv file, sanitizing phone numbers by removing spaces and special characters, then adding +1 to the beginning.
        Simplifies the process by using '-file'and '-newfile' parameters for efficient command-line execution.
        Requires that the source column containing phone numbers is named 'Phone'.

    Audience:
        The audience is technologists looking to update phone numbers contained in .csv's en masse. 
        To run it securely, open an Administrative PowerShell terminal in the same directory as this script and run:

        powershell.exe -executionpolicy bypass -File .\PhoneNumberSanitizer.ps1 -file "sourcefile.csv" -newfile "updatedfile.csv"

    Version:
        2/3/2022 - Original version.

    Return Codes:
        0 - Success
        1 - Failure

    References:
        For adding command-line arguments - https://stackoverflow.com/questions/2157554/how-to-handle-command-line-arguments-in-powershell
        For overwriting the existing column in the table - https://serverfault.com/questions/148339/exporting-specific-fields-with-powershells-export-csv
        For catching any exceptions - https://stackoverflow.com/questions/38419325/catching-full-exception-message

    Author:
        Dean Tammam
        
#>

# Param block for source filename and new filename arguments via terminal.
param (
    [string]$file = $(read-host "Input source filename that you'd like sanitized, please"),
    [string]$newfile = $(read-host "Input the name of the file you'd want once sanitized, please")
)

### Error handling block.

    # Initial variables for log collection.
    $scriptname = "PhoneNumberSanitizer"
    $logfolderpath = "C:\Program Files\_scriptLog"
    $logfilepath = "C:\Program Files\_scriptLog\$($scriptName).log"
    $logtailpath ="C:\Program Files\_scriptLog\$($scriptName)_Transcript.log" 

    # Create our log directory if it doesn't exist.
    if (!(Test-Path -Path $logfolderpath))
        {
            New-Item -ItemType Directory -Force -Path $logfolderpath
        }

    # The write_log function for documenting in our .log file.
    function write_log($message)
        {
            Add-Content $logfilepath "$(Get-Date) - $message"
            Write-Output $message
            $global:event_msg += $message | Out-String
        }

### Script execution block.

    # Begin a tail for logging non-implicitly captured events from the terminal.
    start-transcript -Path $logtailpath -Append

    # Overarching try block for script execution.
    try {
        # Bring in our source .csv.
        $table = Import-CSV -Path $file -Delimiter ',' -Encoding Default
        write_log "Now processing $($file)!"

        # Process the phone numbers.
        foreach ($entry in $table) {
            # Iterate through each of the phone numbers for a given column.
            $phonenumber = $entry.phone
            # RegEx processing to format the numbers how we'd like.
            $phoneupdate = ($phonenumber -replace "\(0\)", "" -replace "[^0-9,^+]", "" -replace "^", "+1")
            write_log "Updating $($phonenumber) to be $($phoneupdate)"
            # Overwrite the existing 'Phone' object in the imported table object with our newly formatted phone number.
            Add-Member -InputObject $entry -MemberType NoteProperty -Name "Phone" -Value $phoneupdate -Force
            }

        # Create our new .CSV using all data from imported table object (including our new 'Phone' data).
        $table | Export-Csv -Path $newfile -Delimiter ',' -NoTypeInformation
        write_log "Exported CSV here: $($newfile)"
        stop-transcript
        Exit 0
    }

    # Handle any errors that occur.
    catch {
        write_log "Script failed with the following exception: $($_)"
        stop-transcript
        Exit 1
    }
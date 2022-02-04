
<#
PhoneNumberSanitizer.ps1

    Goal: 
        Parses through a .csv file and sanitizes phone numbers by removing spaces and special characters then adds +1 to the beginning.
        Simple execution with '-file'and '-newfile' parameters via PowerShell console.
        Requires that the source column containing phone numbers is named 'Phone'.

    Audience:
        For technologists looking to update phone numbers contained in .csv's en masse. 
        To run it securely, open an Administrative PowerShell terminal in the same directory as this script and run:

            powershell.exe -executionpolicy bypass -File .\PhoneNumberSanitizer.ps1 -file "*yourcsv*.csv" -newfile "*yournewcsv*.csv"

        If you have any issues bypassing for the file, you can open an Administrative PowerShell terminal in the same directory as this script and do this instead:

            Set-ExecutionPolicy -bypass
            .\PhoneNumberSanitizer.ps1 -file "sourcefile.csv" -newfile "updatedfile.csv"
            Set-ExecutionPOlicy -restricted

    Version:
        2/3/2022 - Original version.
        2/4/2022 - Minor comment adjustments.

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

# Param block for source filename and new filename arguments via terminal.
param (
    [string]$file = $(read-host "Input source filename that you'd like sanitized, please."),
    [string]$newfile = $(read-host "Input the name of the file you'd want once sanitized, please.")
)

### Error handling block.

    # Initial variables for log collection.
    $scriptname = "PhoneNumberSanitizer"
    $logfolderpath = "C:\Program Files\_scriptLog"
    $logfilepath = "C:\Program Files\_scriptLog\$($scriptname).log"
    $logtailpath ="C:\Program Files\_scriptLog\$($scriptname)_Transcript.log" 

    # Create our log directory if it doesn't exist.
    if (!(test-path -path $logfolderpath))
        {
            new-item -itemtype directory -force -path $logfolderpath
        }

    # The write_log function for documenting in our .log file.
    function write_log($message)
        {
            add-content $logfilepath "$(get-date) - $message"
            write-output $message
            $global:event_msg += $message | out-string
        }

### Script execution block.

    # Begin a tail for logging non-implicitly captured events from the terminal.
    start-transcript -path $logtailpath -append

    # Overarching try block for script execution.
    try {
        # Bring in our source .csv.
        $table = import-csv -path $file -delimiter ',' -encoding default
        write_log "Now processing $($file)!"

        # Process the phone numbers.
        foreach ($entry in $table) {
            # Iterate through each of the phone numbers for a given column.
            $phonenumber = $entry.phone
            # RegEx processing to format the numbers how we'd like.
            $phoneupdate = ($phonenumber -replace "\(0\)", "" -replace "[^0-9,^+]", "" -replace "^", "+1")
            write_log "Updating $($phonenumber) to be $($phoneupdate)"
            # Overwrite the existing 'Phone' object in the imported table object with our newly formatted phone number.
            add-member -inputobject $entry -membertype noteproperty -name "Phone" -value $phoneupdate -force
            }

        # Create our new .CSV using all data from imported table object (including our new 'Phone' data).
        $table | export-csv -path $newfile -delimiter ',' -notypeinformation
        write_log "Newly exported CSV has been created here: $($newfile)"
        stop-transcript
        exit 0
    }

    # Handle any errors that occur.
    catch {
        write_log "Script failed with the following exception: $($_)"
        stop-transcript
        exit 1
    }
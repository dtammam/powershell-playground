
<#
PhoneNumberSanitizer.ps1

    Goal: 
        Parses through a pre-formatted .csv file, strips extraneous characters from phone numbers and then appends a +1 to the beginning of the number so that it can be uploaded to anything needed (phone system, Active Directory, etc.) 
        Simplifies the process by using a -file and -newfile parameter so that you can easily choose the files to sanitize.
        Requires that your column containing phone numbers is named 'Phone'.

    Audience:
        The audience would be technologists looking to update phone numbers in .csv's en masse. 
        To run it securely, open an Administrative PowerShell terminal in the same directory as this script and run it like so:

        powershell.exe -executionpolicy bypass -File .\PhoneNumberSanitizer.ps1 -file "sourcefile.csv" -newfile "updatedfile.csv"

    Version:
        2/3/2022 - Original version

    Return Codes:
        0 - Success
        1 - Failure

    References:
        Dean Tammam's brain after months of learning to code

    Author:
        Dean Tammam

#>

# Param block for filename prompt.
param (
    [string]$file = $(read-host "Input source filename that you'd like sanitized, please"),
    [string]$newfile = $(read-host "Input the name of the file you'd want once sanitized, please")
)

### Error handling block.

    # Initial variables for log collection.
    $scriptname = $MyInvocation.MyCommand.Name
    $logfolderpath = "C:\Program Files\_scriptLog"
    $logfilepath = "C:\Program Files\_scriptLog\$($scriptName).log"
    $logtailpath ="C:\Program Files\_scriptLog\$($scriptName)_Transcript.log" 

    # Create our log directory if it doesn't exist.
    if (!(Test-Path -Path $logfolderpath))
        {
            New-Item -ItemType Directory -Force -Path $logfolderpath
        }

    # The write_log function itself.
    function write_log($message)
        {
            Add-Content $logfilepath "$(Get-Date) - $message"
            Write-Output $message
            $global:event_msg += $message | Out-String
        }

### Script execution block.

    # Begin a tail for logging non-implicitly captured events from the terminal.
    start-transcript -Path $logtailpath -Append

    #Overarching try block for script execution.
    try {
        $table = Import-CSV -Path $file -Delimiter ',' -Encoding Default
        
        write_log "Now processing $($file)!"

        # Processing phone numbers and adding to a new column.
        foreach ($entry in $table) {
            $phonenumber = $entry.phone
            $phoneupdate = ($phonenumber -replace "\(0\)", "" -replace "[^0-9,^+]", "" -replace "^", "+1")
            write_log "Updating $($phonenumber) to be $($phoneupdate)"
            Add-Member -InputObject $entry -MemberType NoteProperty -Name "Phone" -Value $phoneupdate -Force
            }

        # Create our new .CSV.
        $table | Export-Csv -Path $newfile -Delimiter ',' -NoTypeInformation
        write_log "Exported CSV here: $($newfile)"
        stop-transcript
        Exit 0
    }

    catch {
        write_log "Script failed with the following exception: $($_)"
        stop-transcript
        Exit 1
    }
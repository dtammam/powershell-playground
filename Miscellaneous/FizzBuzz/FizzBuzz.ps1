<#
The FizzBuzz problem is a classic test given in coding interviews. The task is simple: Print integers 1 to N, but print “Fizz” if an integer is divisible by 3, “Buzz” if an integer is divisible by 5, and “FizzBuzz” if an integer is divisible by both 3 and 5.

#>

<#
FizzBuzz.ps1

    Goal:
        The purpose of this script is to output integers 1 to N, but print “Fizz” if an integer is divisible by 3, “Buzz” if an integer is divisible by 5, and “FizzBuzz” if an integer is divisible by both 3 and 5.

    Audience:
        JMK

    Version:
        6/23/2022 - Original version

    Return Codes:
        N/A

    References:
        Modulo - https://devblogs.microsoft.com/scripting/powertip-return-remainder-after-dividing-two-numbers/
        PowerShell If/And - https://www.computerperformance.co.uk/powershell/if-and/
#>


    # Global variables for various logging functions
    $ScriptName = "FizzBuzz"
    $LogFolderPath = "C:\Program Files\_scriptLog"
    $LogFilePath = "C:\Program Files\_scriptLog\$($ScriptName).log"
    $LogTailPath = "C:\Program Files\_scriptLog\$($ScriptName)_Transcript.log"

    # Create our log directory if it doesn't exist
    if (!(Test-Path -Path $LogFolderPath)) {
            New-Item -ItemType Directory -Force -Path $LogFolderPath
        }

    # Primary logging function.
    function Write-Log($Message)
        {
            Add-Content $LogFilePath "$(Get-Date) - $Message"
            Write-Output $Message
            $Global:EventMessage += $Message | Out-String
        }

# Overarching Try block for execution

try {
    # Begin a tail for logging non-implicitly captured events from the terminal.
    Start-Transcript -Path $LogTailPath -Append

    Write-Log "Hello one, hello all! It's time to F-f-f-f-f-fizzbuzz!"

    # Reference number and empty counter
    $Seed = Read-Host -Prompt "Please input a starting number"
    $Count = 0
    $FizzCount = 0
    $BuzzCount = 0
    $FizzBuzzCount = 0

    Write-Log "Reticulating splines..."

    # Loop to process fizzbuzz
    while ($Count -lt $Seed) {
        if ($Count % 3 -eq 0 -and $Count % 5 -eq 0) {
            "$($Count) FizzBuzz"
            $FizzBuzzCount += 1
        }

        elseif ($Count % 3 -eq 0) {
            "$($Count) Fizz"
            $FizzCount += 1

        }
        elseif ($Count % 5 -eq 0) {
            "$($Count) Buzz"
            $BuzzCount += 1
        }

        else {
            "$Count"
            }
        $Count += 1
        }

        Write-Log "Thanks for playing!"
        Write-Log ""
        Write-Log "FizzBuzz results:"
        Write-Log "__________________________________________"
        Write-Log ""
        Write-Log "Seed number:             $($Seed)"
        Write-Log "Number of Fizz's:        $($FizzCount)"
        Write-Log "Number of Buzz's:        $($BuzzCount)"
        Write-Log "Number of FizzBuzz's:    $($FizzBuzzCount)"
        Write-Log "__________________________________________"


}

catch {
    Write-Log "Fizzbuzz failed with the following exception: $($_)"
}
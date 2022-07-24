<#
FizzBuzz2.ps1

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
    function Write-Log($Message) {
        Add-Content $LogFilePath "$(Get-Date) - $Message"
        Write-Output $Message
        $Global:EventMessage += $Message | Out-String
    }

# Overarching Try block for execution

try {
    # Begin a tail for logging non-implicitly captured events from the terminal.
    Start-Transcript -Path $LogTailPath -Append

    Write-Log "Hello one, hello all! It's time to F-F-F-F-FizzBuzz!"

    # Reference number and empty counter
    $Seed = Read-Host -Prompt "Please input a starting number"
    $Count = 1
    $FizzCount = 0
    $BuzzCount = 0
    $FizzBuzzCount = 0


    Start-Sleep -Seconds 1
    Write-Log "Reticulating splines."
    Start-Sleep -Seconds 1
    Write-Log "Reticulating splines.."
    Start-Sleep -Seconds 1
    Write-Log "Reticulating splines..."
    Start-Sleep -Seconds 1

    # Loop to process fizzbuzz
    while ($Count -lt $Seed) {
        $FizzState = $false
        $BuzzState = $false
        $Fizz = ""
        $Buzz = ""

        <#if ($Count % 3 -eq 0 -and $Count % 5 -eq 0) {
            $FizzBuzzState = $true
            $FizzBuzzCount += 1
        }
        #>
        if ($Count % 3 -eq 0) {
            $FizzState = $true
            $FizzCount += 1

        }
        if ($Count % 5 -eq 0) {
            $BuzzState = $true
            $BuzzCount += 1
        }

        if ($FizzState -eq $true) {
            $Fizz = "Fizz"
        }

        if ($BuzzState -eq $true) {
            $Buzz = "Buzz"
        }

        if ($FizzState -eq $true -and $BuzzState -eq $true) {
            $FizzBuzzCount += 1
        }

        "$($Count) $($Fizz)$($Buzz)"
        Start-Sleep -Milliseconds 50

        $Count += 1
        }

    Write-Log "Thanks for playing!"
    Write-Log ""
    Write-Log "FizzBuzz results:"
    Write-Log "__________________________________________"
    Write-Log ""
    Start-Sleep -Seconds 2
    Write-Log "Seed number:             $($Seed)"
    Start-Sleep -Seconds 2
    Write-Log "Number of Fizz:          $($FizzCount)"
    Start-Sleep -Seconds 2
    Write-Log "Number of Buzz:          $($BuzzCount)"
    Start-Sleep -Seconds 2
    Write-Log "Number of FizzBuzz:      $($FizzBuzzCount)"
    Start-Sleep -Seconds 2
    Write-Log "Value of this exercise:  Priceless"
}

catch {
    Write-Log "FizzBuzz failed with the following exception: $($_)"
}
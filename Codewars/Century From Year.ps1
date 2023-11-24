<#
Introduction
The first century spans from the year 1 up to and including the year 100, the second century - from the year 101 up to and including the year 200, etc.

Task
Given a year, return the century it is in.

Examples
1705 --> 18
1900 --> 19
1601 --> 17
2000 --> 20
#>

Function Get-CenturyFromYear ([int]$year)
{
    $YearString = [String]$Year
    $TotalDigits = $Year.ToString().Length
    $LastDigit = [int]$TotalDigits - 1

    if ($YearString[$LastDigit] -eq '0') {
        $Century = $Year/100
        Return $Century
    }

    else {
        $Century = ($Year/100) + 1
        Return [int][math]::Truncate($Century)
    }
}

Get-CenturyFromYear(400000)
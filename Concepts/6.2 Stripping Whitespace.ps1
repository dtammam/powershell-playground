<#
Stripping Whitespace

    - Sometimes we want to take a string and remove whitespace at the beginning and/or end
    - TrimStart() and TrimEnd() remove whitespace at the left or right
    - Trim() removes both beginning and ending whitespace
#>

$greet = '                 Hello, Bob!             '
$greet
$greet.TrimStart()
$greet.TrimEnd()
$greet.Trim()
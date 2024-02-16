<#
Conditional Pattern

    - In PowerShell, love IS conditional!
    - An if will process the first true statement
#>

$x = 5

if ($x -lt 10)
    {"Smaller"}

if ($x -gt 20)
    {"Bigger"}

"Finis"
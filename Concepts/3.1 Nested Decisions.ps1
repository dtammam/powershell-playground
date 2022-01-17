<#
Nested Decisions

    - Decisions can be made at multiple levels of loops
    - In this example, we are checking for multiple conditions and can interact accordingly
#>

$w = Read-Host "What is our reference number?"
$x = [int]$w

if ($x -gt 1) {
    "Our number is most certainly larger than 1. Huzzah!"
    if ($x -lt 100) {
        "Our number is also less than 100. Cheerio!"
    }
}

"I am now bored. Goodbye."
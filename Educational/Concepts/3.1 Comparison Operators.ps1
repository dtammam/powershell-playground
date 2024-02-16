<#
Comparison Operators

    - These operators are key syntax to know as we navigate python
    - Most contain more than one character
#>

$w = Read-Host "What is x?"
$x = [int]$w

if ($x -eq 5)
    {"Your number is 5!"}

if ($x -gt 4)
    {"Your number is greater than 4!"}

if ($x -ge 7)
    {"Your number is greater than or equal to 7!"}

if ($x -ne 6)
    {"Your number is definitely NOT 6."}

if ($x -eq 9)
    {"Well, actually, it very well could be a 6."}

"Your number is definitely $x though, I can tell you that."
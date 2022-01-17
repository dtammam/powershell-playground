<#
Indents Don't Matter in PowerShell

    - PowerShell works with and without proper indenting
    - However, it's visually pleasing and easier to process
#>

$x = 1
if ($x -gt 2)
    {
        "This is bigger than 2."
        "I have reconsidered... and realized that it is still bigger than 2."
        "I am now done with the number 2."
    }
else {
    "This is not bigger than 2."
    "That is a crying shame."
    }
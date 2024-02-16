<#
Filtering in a Loop

    - We can create new conditions while looping
    - This allows the loop to continue, while getting what we'd want
#>

"Before"
foreach ($value in @(9, 13, 24, 83, 43, 7)) {
    if ($value -gt 20) {
        "Large number" + " " + $value
    }
}

"After"
<#
Finding the Smallest Number in a Loop

    - The opposite is NOT true. We won't find the smallest starting with a positive number
    - We use the None keyword to start it as null, then the first number becomes the smallest so far
#>

$smallest = $null
"Before" + " " + $smallest

foreach ($value in @(9, 41, 12, 3, 74, 15)) {
    if ($null -eq $smallest) {
        $smallest = $value 
    }
    elseif ($value -lt $smallest) {
        $smallest = $value 
    }
    "$smallest " + "$value "       
}

"After" + " " + $smallest
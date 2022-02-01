<#
Search Using a Boolean Variable

    - This works by setting a string beforehand and then modifying that string during the loop
    - Once detected, we can use that in our results as an easy way to read it
#>

$found = "Not detected"
"Before", $found -join ','

foreach ($value in @(9, 41, 12, 3, 74, 15)) {
    if ($value -eq 3) {
        $found = 'Detected'
    }
    $found, $value -join ','
}
"After", $found -join ','
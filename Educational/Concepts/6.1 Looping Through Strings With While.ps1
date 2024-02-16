<#
Looping Through Strings With While

    - We can loop through a string the same way we loop through other things!
    - In our example below, we are adding to an index variable until we get to the end of our string
#>

$fruit = 'banana'
$fruit = $fruit.tochararray()
$index = 0

while ($index -lt $fruit.Length) {
    $x = $fruit[$index]
    "$($index) $($x)"
    $index += 1
}
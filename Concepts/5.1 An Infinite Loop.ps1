<#
An Infinite Loop

    - Infinite loops occur when the iteration variable has no way of being modified
    - In our example below, n will always be greater than 0, so it will never end
#>

$n = 5

while ($n -gt 0) {
    "Soap!"
    "Water!"
    "Lather!"
}
"Dry off"
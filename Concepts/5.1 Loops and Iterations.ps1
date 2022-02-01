<#
Loops and iterations

    - Loops continually go through and do a thing until the condition is met
    - It iterates based off of an iteration variable
#>

$n = 5

while ($n -gt 0) {
    "$n"
    $n -= 1
}

"Blastoff!"
"$n"
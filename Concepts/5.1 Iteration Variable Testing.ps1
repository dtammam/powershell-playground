<#
Iteration Variable Testing

    - Below is a good example of an iteration variable
    - We set the variable as 3, then have the loop subtract to it until it is no longer meeting the original criteria
#>

$n = 3

"So, I'll need you to clap three times for me before I can let you out of this loop. Can you do that?"

while ($n -gt 0) {
    "*Clap*"
    $n -= 1
}

"Thanks for the claps, bub."
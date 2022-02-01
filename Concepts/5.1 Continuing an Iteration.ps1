<#
Continuing an Iteration

    - Continue is the opposite of break
    - It allows us to continue back in the loop if we otherwise would have stopped it
#>

while ($true) {
    $line = (read-host -prompt "> ")
    if ($line[0] -eq '#') {
        continue
    }
    if ($line -eq "Done") {
        break
    }
    "$line"
}

"Done!"
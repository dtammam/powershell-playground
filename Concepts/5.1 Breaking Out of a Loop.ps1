<#
Breaking Out of a Loop

    - The break command allows us to deliberately stop looping
    - This is useful if we get the result we want and no longer need to continue
#>

"What is the magic word?"

while ($true) {
    $line = (Read-Host -Prompt '> ').ToLower()

    if ($line -eq 'now') {
        "Wow, that was rude."
    }

    elseif ($line -eq 'please') {
        break
    }

    "Magic word not accepted. Try again, please."
}

"Magic word accepted!"
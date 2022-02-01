<#
Counting in a Loop

    - The example below shows how to count on our variable
    - We continually loop through, checking to see if we satisfy the condition
    - After 7, we're done
#>

$plumbus = 0
"This is the magic counting machine. It breaks after 7 plumbuses, so avoid doing this."

"Before, " + $plumbus
foreach ($bibbitybop in @(9, 41, 12, 3, 74, 15, 95, 2)) {
    $plumbus += 1
    if ($plumbus -ge 7) {
        "Um, did you not read the instructions? The machine is now broken..."
        break
    }
    $plumbus, $bibbitybop -join ','
}

"After, " + $plumbus
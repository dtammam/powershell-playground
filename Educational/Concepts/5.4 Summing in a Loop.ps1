<#
Summing in a Loop

    - Similar to counting, except we're using variables total and runningtotal
    - This starts at 0, and continues to increase as we add to it in our loop
#>

$total = 0
"Before " + $total
foreach ($runningtotal in @(9, 41, 12, 3, 74, 15)) {
    $total += $runningtotal
    "$total" + " " + "$runningtotal"
}
"After " + $total
<#
Finding the Average in a Loop

    - Averaging is simply dividing the sum of numbers by the total number of numbers included
    - We represent this with multuple variables - sum, count and value
#>

$count = 0
$sum = 0
"Before", $count, $sum -join ','
foreach ($value in @(9, 41, 12, 3, 74, 15)) {
    $count +=1
    $sum += $value
    $count, $sum, $value -join ','
}
"After", $count, $sum, ($sum / $count) -join ','
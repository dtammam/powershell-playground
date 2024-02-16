<#
Looping Through Strings With For (Elegant)

    - This solution is way better
    - We are simply iterating off of the variable for each character inside it versus creating a new code section for it
#>

$fruit = 'banana'
$fruit = $fruit.ToCharArray()
foreach ($letter in $fruit) {
    $letter
}
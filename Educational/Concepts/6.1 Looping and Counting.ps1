<#
Looping and Counting

    - We can selectively count certain elements as we loop
    - In this example, we only want to know how many letter 'a' exist in the word
#>

$word = 'banana'
$word = $word.ToCharArray()
$count = 0

foreach ($letter in $word) {
    if ($letter -eq 'a') {
        $count += 1
    }
}

$count
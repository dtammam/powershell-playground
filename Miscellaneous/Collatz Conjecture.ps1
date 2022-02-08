<#
Collatz Conjecture

- The goal of this script is to functionally execute the idea behind the Collatz Conjecture (https://en.wikipedia.org/wiki/Collatz_conjecture)
- Prompts the user for a number to test and counts the operations taken to get to 1.
- Very simple execution of the idea. Not using a function, likely could for efficiencies' sake.
- Last thing to do is to sanitize inputs to accept only numbers (will do in the near future).
#>

$prompt = read-host -prompt "Please input a number"
$number = $prompt
$count = 0 

"The original number is " + $number + "."

while ($true) {
    if ($number -eq 1) {
        break
    }
    elseif ($number % 2 -eq 0) {
        "$number is even, continuing."
        $number /= 2
        "Number is now " + $number + "."
        $count += 1
        continue
    }
    elseif ($number % 2 -ne 0) {
        "$number is odd, continuing."
        $number = ($number * 3) + 1
        "Number is now " + $number + "."
        $count += 1
        continue
    }
}
"It took " + $count + " operations to get to 1!"
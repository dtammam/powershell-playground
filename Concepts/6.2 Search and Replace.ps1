<#
Search and Replace

	- The replace() function is like a "search and replace" operation in a word processor
    - It replaces all occurrences of the search string with the replacement string
#>

$greet = 'Hello Bob!'
$subjane = $greet.Replace('Bob','Jane')
$subjane

$subx = $greet.Replace('o','X')
$subx
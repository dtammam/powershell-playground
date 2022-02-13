<#
Slicing Strings

    - We can slice as a character array using the range '..' operator
    - We can also use the Substring() method
    
#>

# M o n t y   P y t h  o  n
# 0 1 2 3 4 5 6 7 8 9 10 11

$s = 'Monty Python'
$s[0..3] -join ''
$s[6..6] -join ''
$s[6..20] -join ''

$t = 'Mommy Dearest'
$t.Substring(0,5)
$t[6..($t.length-1)] -join ''
$t.Substring(0,13)
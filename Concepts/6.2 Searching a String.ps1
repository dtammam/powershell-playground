<#
Searching a String

    - We use the IndexOf() function to search for a substring within another string
    - IndexOf() finds the first occurrence of the substring
    - If the substring is not found, IndexOf() returns -1
    - Remember that string positions start at 0
#>

$fruit = 'banana'
$pos = $fruit.IndexOf('na')
$pos

$aa = $fruit.IndexOf('z')
$aa
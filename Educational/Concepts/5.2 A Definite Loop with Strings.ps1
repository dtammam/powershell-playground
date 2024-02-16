<#
A Definite Loop with Strings

    - This is the same as before, except now we're doing strings
    - We have 5 strings and we are using 'friend' as the iteration variable
    - You could use anything, this is just easier for us humans to read
#>

$friends = @("Preston", "Alex K.", "Alex M.", "Mont", "Ray", "DeWitt")
foreach ($friend in $friends) {
    "How's it goin, my buddy" + " " + $friend + "?"
}
"Done!"
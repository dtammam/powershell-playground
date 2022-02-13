<#
Making everything UPPERCASE

    - You can make a copy of a string in lower case or upper case
    - Often when we are searching for a string using find() we first convert the string to lower case so we can search a string regardless of case
#>

$greet = 'Hello Bob!'
$nnn = $greet.ToUpper()
$nnn

$www = $greet.ToLower()
$www
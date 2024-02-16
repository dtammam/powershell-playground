<#
String Comparison

    - -lt and -gt work for letters
    - Z is -lt a
#>

$word = Read-Host('Please input a word:')

if ($word -eq 'banana') {
    "All right, bananas."
}

if ($word -lt 'banana') {
    "Your word, " + $word + ", comes before banana."
}

elseif ($word -gt 'banana') {
    "Your word, " + $word + ", comes after banana."
}

else {
    "Bananas."
}
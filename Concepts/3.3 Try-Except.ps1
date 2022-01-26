<#
Try-Except

    - Like a try/else, except...
    - Except is a way to prevent a try if needed
#>

$rawstr = Read-Host "Please enter a number"

try {
    $ival = [int]$rawstr
}

catch {
    $ival = -1
}

if ($ival -gt 0) {
    "Nice work, $ival is a nice number. Really nice number you've got there"
}

else {
    "Sorry, but that isn't a number."
}
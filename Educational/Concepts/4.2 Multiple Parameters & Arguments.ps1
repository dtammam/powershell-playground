<#
Multiple Parameters & Arguments

    - We can set many parameters in a function
    - This allows them to be used for more useful calculations
#>

function addtwo($a, $b) {
    $added = $a + $b
    return $added      
}

$x = addtwo -a 3 -b 5
$x
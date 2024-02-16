<#
Function Parameters

    - Function parameters allow us to sub in values for functions
    - They are very useful and are the 'backend' operators for functions
#>

function greet($lang) {
    if ($lang -eq 'es') {
        "Hola!"
    }
    elseif ($lang -eq 'fr') {
        "Bonjour!"
    }
    else {
        "Hello!"
    }
}

greet -lang "fr"
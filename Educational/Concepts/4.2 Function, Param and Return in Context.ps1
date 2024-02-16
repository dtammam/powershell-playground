<#
Function, Param and Return in Context

    - You can see a proper example of all elements below
    - Note the printing of greet(), we need to call it for it to run
#>

function greet($lang) {
    if ($lang -eq 'es') {
        return "Hola"
    }
    elseif ($lang -eq 'fr') {
        return "Bonjour"
    }
    else {
        return "Hello"
    }
}

(greet -lang "es") + " Glenn"
(greet -lang "en") + " Sally"
(greet -lang "fr") + " Michael"
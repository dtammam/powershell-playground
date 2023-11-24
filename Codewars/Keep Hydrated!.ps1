Function StayHydrated($Time){

    <#
    .SYNOPSIS
        Determines optimal hydration level based on time exercising.
    .DESCRIPTION
        Determines optimal hydration level based on time exercising, rounded down based on how much time has passed.
    .PARAMETER $Time
        The amount of time to account for in hours.
    .EXAMPLE
        StayHydrated(6.7)
    #>

    $Drink = 0.5
    $Consumed = ($Time*$Drink)
    $Final = [Math]::Floor($Consumed)
    return $Final
}

StayHydrated(6.7)
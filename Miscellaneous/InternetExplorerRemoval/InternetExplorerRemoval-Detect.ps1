<#
InternetExplorerRemoval-Detect.ps1

    Goal:
        Custom script-based detection logic for Intune.
    
    Audience:
        Techs removing Internet Explorer via Intune.

    Version:
        8/6//2022 - Original version

    Return Codes:
        0 - Detected (Condition met)
        1 - Not detected (Condition failed, run real script

    Author:
        Dean Tammam

    References:
        Microsoft documentation for app detection rules - https://docs.microsoft.com/en-us/mem/intune/apps/apps-win32-add#step-4-detection-rules
#>

$Result = Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -eq 'Internet-Explorer-Optional-amd64'}

If ($Result.State -ne "Enabled") {
    Write-Output "Internet Explorer is disabled."
    Exit 0
}

Else {
    Exit 1
}
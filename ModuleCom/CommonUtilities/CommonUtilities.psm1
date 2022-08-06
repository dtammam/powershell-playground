<#
ScreenshotCopy.ps1

    Goal:
        Save time
        One place to maintain useful code
        Extend and modify funcions and all scripts that use it immediately
        Makes caling scripts more readable
        Portable and sharable

    Audience:
        PowerShell scripters who want to leverage modules

    Version:
        8/6/2022 - Original version
#>

#  Get the path to the function files...
$FunctionPath = $PSScriptRoot + "\Function\"

# Get a list of all the function file names...
$FunctionList = Get-ChildItem -Path $FunctionPath -Name 

#  Loop over alll the files and dot source them into memory..
foreach ($Function in $FunctionList) {
    . ($FunctionPath + $Function) 
}
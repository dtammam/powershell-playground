<#
.SYNOPSIS
    Sets the 'LastKey' registry key to open regedit to the desired key.
.DESCRIPTION
    The Set-LastKey function updates the 'LastKey' registry key in the path
    'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit'. 
    This key determines the default location that regedit opens to. By setting this key, 
    you can control the initial location that regedit navigates to upon opening.
.PARAMETER DesiredKey
    The registry path that you want regedit to open to by default.
.EXAMPLE
    .\RegLauncher.ps1 -DesiredKey "HKEY_CURRENT_USER\Software\Microsoft"

    This command sets the 'LastKey' registry key to open regedit to the path "HKEY_CURRENT_USER\Software\Microsoft".
.EXAMPLE
    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Repo\RegLauncher.ps1" -DesiredKey 
    "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

    This Target within a Windows shortcut facilitates one opening the 32-bit Uninstall key within Regedit.
.NOTES
    Useful when creating shortcuts to target keys, so you can use a shortcut to quickly access the target key.
#>

# Define the parameter for the script
param (
    [Parameter(Mandatory)]
    [String]$DesiredKey
)
function Set-LastKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$DesiredKey
    )
    try {
        Write-Host "Setting 'LastKey' registry key to open regedit to the desired key..."
        reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v LastKey /t REG_SZ /d $DesiredKey /f
        Write-Host "Set the 'LastKey' registry key successfully."
    } catch {
        Write-Error "Failed to set the 'LastKey' registry key."
    }
}

# Call the function using the script parameter
Set-LastKey -DesiredKey $DesiredKey
Start-Process -FilePath regedit.exe -ArgumentList "/m"
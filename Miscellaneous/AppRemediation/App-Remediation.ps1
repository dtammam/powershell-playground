<#
App-Remediation.ps1

    Goal:
        This script automates the remediation of an app.

    Audience:
        Technologists looking to automate app remediation via RMM software.

    Version:
        8/6/2022 - Original version

    Return Codes:
        0 - Success
        1 - Failure

    References:
        N/A

    Author:
        Dean Tammam
#>

# If we are running as a 32-bit process on a 64-bit system, re-launch as a 64-bit process
if ("env:PROCESSOR_ARCHITEW6432" -ne "ARM64") {
    if (Test-Path "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe") {
        & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy bypass -NoProfile -File "$PSCommandPath"
    }
}

# Create relevant global variables and event log
$Global:EventMessage = ''
$Global:EventSource = 'App-Remediation'
$Global:EventLogName = 'Application'
New-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -MessageResourceFile 'C:\Windows\Microsoft.NET\v4.0.30319\EventLogMessages.dll' -ErrorAction SilentlyContinue

# Make sure the script can run as needed and start logging
Set-ExecutionPolicy Bypass
Start-Transcript -Path "C:\Program Files\SetupLog\$($Global:EventSource).log" -Append

# Function for checking registry state
function Get-RegistryValueState ($Path, $Value) {
    try {
        Get-ItemProperty -Path $Path -Name $Value -ErrorAction $Stop | Out-Null
        Return $true
    }
    catch {
        Return $false
    }
}

try {
    # Download relevant files
    Write-Output "Downloading relevant files..."

    Invoke-WebRequest -Uri "https://www.example.com/Install.exe" -OutFile "C:\Apps\Install.exe" -ErrorAction Stop
    Invoke-WebRequest -Uri "https://www.example.com/Cleanup.msi" -OutFile "C:\Apps\Cleanup.msi" -ErrorAction Stop

    # Check install status by package registry key
    Write-Output "Pre-remediation: Checking is app is installed..."
    if ((Get-RegistryValueState 'HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications' 'Windows_App-Latest') -eq $true) {
        Write-Output "Re-remediation: The app is installed."
    }
    else {
        Write-Output "Pre-remediation: The app is not installed."
    }

    # Output the current state of the service for clarity
    Write-Output "Pre-remediation: Getting state of app service..."

    $AppState = Get-Service -Name "App Controller" -ErrorAction SilentlyContinue
    if ($null -eq $AppState) {
        Write-Output "Pre-remediation: App service is currently not detected."
    }
    else {
        Write-Output "Pre-remediation: App service is currently $($AppState.Status)"
    }

    # Get state of settings.bin for historical reference/validating that it changed
    $SettingsDotBin = "C:\Program Files\App\App Files\bin\settings.bin"

    Write-Output "Pre-remediation: Checking settings.bin..."
    if (Test-Path $SettingsDotBin) {
        $SettingsDotBinSize = (Get-Item $SettingsDotBin).Length
        $SettingsDotBinSizeKB = [System.Math]::Round((($SettingsDotBinSize)/1KB),2)
        Write-Host "Pre-remediation: settings.bin:"SettingsDotBinSizeKB"KB"
    }
    else {
        Write-Output "Pre-remediation: settings.bin is not detected."
    }

    # Uninstall app
    Write-Output "Remediation: Beginning uninstall..."
    Start-Process -FilePath "C:\Apps\Install.exe" -ArgumentList "/s /u" -Wait -ErrorAction Stop
    Write-Output "Remediation: Uninstall complete."

    # Cleanup app
    Write-Output "Remediation: Beginning cleanup..."
    Start-Process -FilePath "C:\Apps\Cleanup.msi" -Wait -ErrorAction Stop
    Write-Output "Remediation: Cleanup complete."

    # Check install status by package registry key
    Write-Output "Remediation: Checking is app is installed..."
    if ((Get-RegistryValueState 'HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications' 'Windows_App-Latest') -eq $true) {
        Write-Output "Remediation: The app is installed."
    }
    else {
        Write-Output "Remediation: The app is not installed."
    }

    # Confirm that the service is gone
    $AppState = Get-Service -Name "App Controller" -ErrorAction SilentlyContinue
    if ($null -eq $AppState) {
        Write-Output "Remediation: After uninstall, app service is not detected."
    }
    else {
        Write-Output "Remediation: After uninstall, app service is still there and is currently $($AppState.Status)"
    }

    # Reinstall app
    Write-Output "Remediation: Beginning install..."
    Start-Process -FilePath "C:\Apps\Install.exe" -ArgumentList "/s /u" -Wait -ErrorAction Stop
    Write-Output "Remediation: Install complete."

    # Validate post-install
    Write-Output "Post-remediation: Allowing device to process..."
    Start-Sleep -Seconds 60

    $AppState = Get-Service -Name "App Controller" -ErrorAction SilentlyContinue
    if ($null -eq $AppState) {
        Write-Output "Post-remediation: App service is stopped. Restarting it..."
        Restart-Service -Name "App Controller" -Force -ErrorAction Continue
        Start-Sleep -Seconds 30
    }
    $AppState = Get-Service -Name "App Controller" -ErrorAction SilentlyContinue
    Write-Output "Post-remediation: App service has been restarted. App service is currently $($AppState.Status)"

    # Check install status by package registry key
    Write-Output "Post-remediation: Checking is app is installed..."
    if ((Get-RegistryValueState 'HKLM:\SOFTWARE\WOW6432Node\RegisteredApplications' 'Windows_App-Latest') -eq $true) {
        Write-Output "Post-remediation: The app is installed."
    }
    else {
        Write-Output "Post-remediation: The app is not installed."
    }

    # Output the current state of the service for clarity
    Write-Output "Post-remediation: Getting state of app service..."

    $AppState = Get-Service -Name "App Controller" -ErrorAction SilentlyContinue
    if ($null -eq $AppState) {
        Write-Output "Post-remediation: App service is currently not detected."
    }
    else {
        Write-Output "Post-remediation: App service is currently $($AppState.Status)"
    }

    # Get state of settings.bin for historical reference/validating that it changed
    $SettingsDotBin = "C:\Program Files\App\App Files\bin\settings.bin"

    Write-Output "Post-remediation: Checking settings.bin..."
    if (Test-Path $SettingsDotBin) {
        $SettingsDotBinSize = (Get-Item $SettingsDotBin).Length
        $SettingsDotBinSizeKB = [System.Math]::Round((($SettingsDotBinSize)/1KB),2)
        Write-Host "Post-remediation: settings.bin:"SettingsDotBinSizeKB"KB"
    }
    else {
        Write-Output "Post-remediation: settings.bin is not detected."
    }

    # Cleanup and exit script
    Write-Output "App remediated successfully. Cleaning up..."
    Remove-Item -Path "C:\Apps\Install.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Apps\Cleanup.msi" -Force -ErrorAction SilentlyContinue
    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventID '601' -Message "App remediation failed. Service state is now $(SAppState.Status), relevant file size is now $($SettingsDotBinSizeKB)KB" | Out-String
    Stop-Transcript
    Exit 0
    }

catch {
    # Cleanup and exit script
    Write-Output "Script failed with the following exception: $($_)."
    Write-Output "Cleaning up..."
    Remove-Item -Path "C:\Apps\Install.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Apps\Cleanup.msi" -Force -ErrorAction SilentlyContinue
    Write-EventLog -LogName $Global:EventLogName -Source $Global:EventSource -EntryType Information -EventID '603' -Message "App remediation failed. Service state is now $(SAppState.Status), relevant file size is now $($SettingsDotBinSizeKB)KB" | Out-String
    Stop-Transcript
    Exit 1
}
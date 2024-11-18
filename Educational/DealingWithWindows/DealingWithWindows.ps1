function Find-AndCloseWindow {
    <#
    .SYNOPSIS
        Finds a window by its title and optionally closes it.

    .DESCRIPTION
        This function enumerates through all open windows on the system and searches for a window
        with a title that matches the specified target name. If the window is found, the function
        returns the handle of the window. If the `-CloseWindow` switch is used, the function also
        sends a WM_CLOSE message to close the window.

    .PARAMETER TargetWindowName
        The name (or part of the name) of the window to search for. The match is case-insensitive
        and supports wildcard patterns.

    .PARAMETER CloseWindow
        A switch that indicates whether to close the found window. If this switch is specified,
        the function sends a WM_CLOSE message to the window.

    .OUTPUTS
        IntPtr
            Returns the handle of the found window if successful, or `$null` if no matching window
            is found.

    .NOTES
        - This function uses WinAPI calls via the Add-Type cmdlet to define required P/Invoke
          methods.
        - Ensure the script is executed with the necessary permissions to interact with window
          handles.

    .EXAMPLE
        Find-AndCloseWindow -TargetWindowName "Task Manager" -CloseWindow

        Finds a window with "Task Manager" in its title and closes it.

    .EXAMPLE
        Find-AndCloseWindow -TargetWindowName "Notepad"

        Finds a window with "Notepad" in its title and returns its handle without closing it.
    #>

    param (
        [string]$TargetWindowName,
        [switch]$CloseWindow
    )

    # Ensure the WinAPI type is defined
    if (-not ([System.Management.Automation.PSTypeName]'WinAPI').Type) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    public const uint WM_CLOSE = 0x0010;
}
"@
        Write-Host "WinAPI type added successfully."
    } else {
        Write-Host "WinAPI type already exists, skipping Add-Type."
    }

    # Variable to store the found window handle
    $script:foundWindow = [IntPtr]::Zero

    # Callback function for EnumWindows
    $callback = {
        param(
            [IntPtr]$hWnd,
            [IntPtr]$lParam
        )

        $title = New-Object System.Text.StringBuilder 256
        [WinAPI]::GetWindowText($hWnd, $title, $title.Capacity) > 0 | Out-Null

        if ($title.ToString() -like "*$TargetWindowName*") {
            Write-Host "Found: $($title.ToString())"
            $script:foundWindow = $hWnd
            return $false # Stop enumeration
        }

        return $true # Continue enumeration
    }

    # Use the callback to find the window
    [WinAPI]::EnumWindows([WinAPI+EnumWindowsProc]$callback, [IntPtr]::Zero)

    # If found, optionally close the window
    if ($script:foundWindow -ne [IntPtr]::Zero) {
        Write-Host "Window with name '$TargetWindowName' found."

        if ($CloseWindow) {
            Write-Host "Closing window..."
            [WinAPI]::PostMessage($script:foundWindow, [WinAPI]::WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
        }

        return $script:foundWindow
    } else {
        Write-Host "Window with name '$TargetWindowName' not found."
        return $null
    }
}

Find-AndCloseWindow -TargetWindowName "Task Manager" -CloseWindow
Find-AndCloseWindow -TargetWindowName "Messenger" -CloseWindow
Find-AndCloseWindow -TargetWindowName "Untitled" -CloseWindow
Find-AndCloseWindow -TargetWindowName "Notepad" -CloseWindow
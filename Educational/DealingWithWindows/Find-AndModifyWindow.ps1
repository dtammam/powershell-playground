function Find-AndModifyWindow {
    <#
    .SYNOPSIS
        Finds windows by their title and optionally closes, maximizes, or lists matching ones.

    .DESCRIPTION
        Enumerates through all open windows and searches for those matching the specified target
        title. If multiple windows match, the function lists them, allowing interaction with a
        specific one using additional logic.

    .PARAMETER TargetWindowName
        The name (or part of the name) of the windows to search for. Supports case-insensitive
        and wildcard patterns.

    .PARAMETER Action
        Specifies the action to take on the found window(s). Options:
        - "List" to list all matching windows.
        - "Close" to close the first matching window.
        - "Maximize" to maximize the first matching window.
        If not specified, defaults to "List".

    .PARAMETER WindowIndex
        Specifies the index of the window to act upon when multiple matches are found (0-based).

    .OUTPUTS
        IntPtr[]
            Returns the handles of all matching windows.

    .EXAMPLE
        Find-AndModifyWindow -TargetWindowName "Notepad" -Action List

        Lists all open windows containing "Notepad" in their title.

    .EXAMPLE
        Find-AndModifyWindow -TargetWindowName "Notepad" -Action Maximize -WindowIndex 1

        Maximizes the second Notepad window found.
    #>

    param (
        [string]$TargetWindowName,
        [ValidateSet("List", "Close", "Maximize")]
        [string]$Action = "List",
        [int]$WindowIndex = 0
    )

    # Ensure the WinAPI type is defined
    if (-not ([System.Management.Automation.PSTypeName]'WinAPI').Type) {
        Add-Type -TypeDefinition @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public const uint WM_CLOSE = 0x0010;
    public const int SW_MAXIMIZE = 3;
}
"@
    }

    # Variables to store matching windows
    $script:matchingWindows = @()

    # Callback function for EnumWindows
    $callback = {
        param(
            [IntPtr]$hWnd,
            [IntPtr]$lParam
        )

        $title = New-Object System.Text.StringBuilder 256
        if ([WinAPI]::GetWindowText($hWnd, $title, $title.Capacity) -gt 0) {
            if ($title.ToString() -like "*$TargetWindowName*") {
                $script:matchingWindows += @{
                    Handle = $hWnd
                    Title = $title.ToString()
                }
            }
        }

        $true # Continue enumeration
    }

    # Find matching windows
    [WinAPI]::EnumWindows([WinAPI+EnumWindowsProc]$callback, [IntPtr]::Zero)

    if ($script:matchingWindows.Count -eq 0) {
        Write-Host "No windows found matching '$TargetWindowName'."
        return $null
    }

    # List matching windows
    if ($Action -eq "List") {
        Write-Host "Matching windows:"
        $script:matchingWindows | ForEach-Object { $_.Handle -as [string] + " - " + $_.Title } | Out-Host
        return $script:matchingWindows
    }

    # Act on the specific window index
    if ($WindowIndex -ge $script:matchingWindows.Count) {
        Write-Host "Invalid WindowIndex. Available windows: 0 to $($script:matchingWindows.Count - 1)."
        return $null
    }

    $selectedWindow = $script:matchingWindows[$WindowIndex]

    Write-Host "Selected window: $($selectedWindow.Title)"

    switch ($Action) {
        "Close" {
            Write-Host "Closing window..."
            [WinAPI]::PostMessage($selectedWindow.Handle, [WinAPI]::WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
        }
        "Maximize" {
            Write-Host "Maximizing window..."
            [WinAPI]::ShowWindow($selectedWindow.Handle, [WinAPI]::SW_MAXIMIZE) | Out-Null
        }
    }

    return $selectedWindow.Handle
}

Find-AndModifyWindow -TargetWindowName "Notepad" -Action Close
Find-AndModifyWindow -TargetWindowName "ChatGPT" -Action Maximize -WindowIndex 1
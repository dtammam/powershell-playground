
function Write-Log {
  [CmdletBinding()]  # Required for using verbose, debug, etc. options
    param(
        [Parameter(Mandatory=$true)]
        [string] $Message
    )

    begin {}

    process{
        Add-Content -Path $logFilePath -Value "$(Get-Date) - $Message"
        Write-Output $Message
        $global:event_msg += $Message | Out-String
    }

    end{}
}
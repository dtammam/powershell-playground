function Export-Certificates {
<#
.SYNOPSIS
Exports certificates based on a specific pattern from a file.

.DESCRIPTION
The Export-Certificates function reads content from a specified file, searches for certificates based on the provided pattern, 
and then exports each matched certificate to a separate file in the specified output directory.

.PARAMETER FilePath
The path to the file containing certificates to be exported.

.PARAMETER Pattern
The regex pattern to use for matching certificates in the file.

.PARAMETER NamingScheme
The naming scheme to use for the exported certificate files.

.PARAMETER OutputDirectory
The directory where the exported certificate files will be saved.

.EXAMPLE
Export-Certificates -FilePath 'C:\path\to\file.txt' -Pattern 'your-regex-pattern' -NamingScheme 'MyCert' -OutputDirectory 'C:\output\directory'
Exports certificates from 'C:\path\to\file.txt', names them with the 'MyCert' prefix, and saves them in 'C:\output\directory'.
#>
    param (
        [ValidateNotNullOrEmpty()]    
        [string]$FilePath,
        [ValidateNotNullOrEmpty()]
        [string]$CertificatePattern,
        [ValidateNotNullOrEmpty()]
        [string]$NamingScheme,
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory
    )

    # Initialize a result hashtable for validation at the end
    $result = @{
        Success = $false
        MatchCount = 0
        ExportedCount = 0
        Message = ""
    }

    try {
        # Ensure the file exists
        if (-not (Test-Path $FilePath)) {
            throw "File [$FilePath] does not exist."
        }

        # Read the contents of the file
        $content = Get-Content -Path $FilePath -Raw

        # Find all matches
        $matches = [regex]::Matches($content, $CertificatePattern)

        # If we find no matches, consider this a failure
        $result.MatchCount = $matches.Count

        if ($matches.Count -eq 0) {
            $result.Message = "No matches found in the file."
            return $result
        }

        $counter = 0

        # For each pattern detected, export it as a .pem file
        foreach ($match in $matches) {
            $outputFileName = "${NamingScheme}$($counter + 1).pem"
            $outputFile = Join-Path -Path $OutputDirectory -ChildPath $outputFileName
            $match.Value | Out-File $outputFile
            Write-Output "Saved: [$outputFileName]"
            $counter++
        }

        # If our counter matches the number of patterns matched, we 
        if ($counter -eq $result.MatchCount) {
            $result.Success = $true
            $result.Message = "[$counter] certificates exported successfully."
            $result.ExportedCount = $counter
        } else {
            throw "Detected [$($result.MatchCount)] matches but only exported [$counter] certificates."
        }
    } catch {
        $result.Message = $_.Exception.Message
    }

    # Return a hashtable with the outcome of the export process
    return $result
}

# Define function-specific variables for the case-at-hand
$FilePath = 'C:\Repositories\PowerShell-Scripts\ExportingFromCertificates\test.crt'
$CertificatePattern = '-----BEGIN CERTIFICATE-----\r?\n([\s\S]*?)\r?\n-----END CERTIFICATE-----'
$NamingScheme = "ContosoInc"
$OutputDirectory = 'C:\Repositories\PowerShell-Scripts\ExportingFromCertificates'

# Variable to execute our function with so that 
$executionResult = Export-Certificates -FilePath $FilePath -CertificatePattern $CertificatePattern -NamingScheme $NamingScheme -OutputDirectory $OutputDirectory

if ($executionResult.Success) {
    Write-Output "Function succeeded: [$($executionResult.Message)]"
} else {
    Write-Output "Function failed: [$($executionResult.Message)]"
}
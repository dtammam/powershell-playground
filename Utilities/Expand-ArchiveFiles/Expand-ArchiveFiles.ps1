function Expand-ArchiveFiles {
<#
.SYNOPSIS
    Expands ZIP archive files from a source directory to a target directory.
.DESCRIPTION
    This function searches for all .zip files within a specified source directory and extracts them to a target 
    directory. If the target directory does not exist, it attempts to create it. The function also provides the option
    to delete the archive files after extraction. It outputs the duration of each extraction process and the total
    count of processed archives.
.PARAMETER SourceDirectory
    The path to the directory containing the ZIP files to be extracted. This parameter must be a valid directory 
    path as a string.
.PARAMETER TargetDirectory
    The path to the directory where the ZIP files will be extracted to. If this directory does not exist, 
    the function will attempt to create it. This parameter must be a valid directory path as a string.
.EXAMPLE
    PS> Expand-ArchiveFiles -SourceDirectory "C:\Source" -TargetDirectory "C:\Target"
    Expands all ZIP files from C:\Source to C:\Target, creating the target directory if it doesn't exist, and 
    reports each extraction's duration.
.INPUTS
    None. You cannot pipe objects to Expand-ArchiveFiles.
.OUTPUTS
    String. Outputs the process of verification, creation (if applicable), extraction of ZIP files, and deletion
     (if applicable), including any errors encountered.
.NOTES
    - The function currently only supports .zip files. Future enhancements may include support for .rar files.
    - The deletion feature needs to be verified for proper functionality.
    - Special consideration for handling illegal characters in file and directory names is planned for future updates.
#>
    [CmdletBinding()]
    param(
        [string]$SourceDirectory,
        [string]$TargetDirectory
    )

    try {
        # Verify if the SourceDirectory exists
        if (-not (Test-Path -Path $SourceDirectory)) {
            Write-Output "Source directory does not exist: $SourceDirectory"
            return
        }

        # Verify if the TargetDirectory exists; try to create it if not
        if (-not (Test-Path -Path $TargetDirectory)) {
            Write-Output "Target directory does not exist, attempting to create: $TargetDirectory"
            New-Item -Path $TargetDirectory -ItemType Directory | Out-Null
        }

        # Verify access to TargetDirectory
        try {
            Test-Path -Path $TargetDirectory -ErrorAction Stop | Out-Null
        } catch {
            Write-Output "Cannot access TargetDirectory: $TargetDirectory"
            return
        }

        # Find all archive files in the SourceDirectory
        $archives = Get-ChildItem -Path $SourceDirectory -Filter *.zip

        foreach ($archive in $archives) {
            # We are looking to extract to our predetermined location
            $destinationPath = $TargetDirectory
            [int]$totalArchiveCount = 0

            # Replace illegal characters in the filename
            $safeFileName = $archive.Name -replace '[\\/:*?"<>|]', ''

            # Construct the safe destination path
            $destinationPath = Join-Path -Path $TargetDirectory -ChildPath $safeFileName

            Write-Output $safeFileName.FullName
            $duration = Measure-Command {
                # Keep track of how long it takes to unzip, and a count of how many we unzip
                Expand-Archive -Path $safeFileName.FullName -DestinationPath $destinationPath -Force
                $totalArchiveCount++
            }
            
            # Write the result
            Write-Output "Extracting [`"$($safeFileName.Name)`"] to [`"$destinationPath`"] took [$($duration.TotalSeconds)] seconds."

            # If it is a .zip file, delete it once extracted
            if ($safeFileName.FullName -like '*.zip') {
                Remove-Item -Path $safeFileName.FullName -Force
                Write-Output "Deleted [`"$($safeFileName.Name)`"] from [`"$SourceDirectory`"]"
            }

        }
    } catch {
        Write-Error "Failed to complete with the following exception: [$($_.Exception.Message)]"
    } finally {
        # Output how many we handled
        if ($totalArchiveCount -eq 1) {
            Write-Output "Completed the process for [$($totalArchiveCount)] .zip file."
        } else {
            Write-Output "Completed the process for [$($totalArchiveCount)] .zip files."
        }
    }
}
Expand-ArchiveFiles -SourceDirectory "C:\Users\dean\Downloads\Packs" -TargetDirectory "\\CLEARBOOK\Games\ITGMania 0.8.0\Songs" -Verbose

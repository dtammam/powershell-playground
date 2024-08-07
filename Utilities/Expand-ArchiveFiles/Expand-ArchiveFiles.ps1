function Expand-ArchiveFiles {
    <#
    .SYNOPSIS
        Extracts all .zip files from a specified source directory to a target directory.
    .DESCRIPTION
        This function checks for the existence of the source and target directories, creates the target 
        directory if it does not exist, and then proceeds to extract each .zip file found in the source 
        directory to the target directory. Each file is extracted to a temporary directory first to measure 
        the time taken for extraction, and then moved to the final destination. 
        The function also handles the deletion of the original .zip files post-extraction.
    .PARAMETER SourceDirectory
        The directory path where the .zip files are located.
    .PARAMETER TargetDirectory
        The directory path where the .zip files should be extracted to.
    .EXAMPLE
        Expand-ArchiveFiles -SourceDirectory "C:\Users\dean\Downloads\Packs" -TargetDirectory "\\CLEARBOOK\Games\ITGMania 0.8.0\Songs"

        Extracts all .zip files from "C:\Users\dean\Downloads\Packs" to "\\CLEARBOOK\Games\ITGMania 0.8.0\Songs".
    .NOTES
        This function requires at least PowerShell 5.0 due to the usage of the Expand-Archive cmdlet.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceDirectory,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
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
            Write-Output "Cannot access target directory [$TargetDirectory]"
            return
        }

        # Find all archive files in the SourceDirectory
        $archives = Get-ChildItem -Path $SourceDirectory -Filter *.zip

        if ($null -eq $archives) {
            Write-Output "No archives found in source directory [$sourceDirectory]."
            [int]$totalArchiveCount = 0
            return
        }

        foreach ($archive in $archives) {
            # We are looking to extract to our predetermined location
            $destinationPath = $TargetDirectory
            
            # Replace illegal characters in the filename
            $safeFileName = $archive.Name -replace '[\\/:*?"<>|]', ''

            # Construct the safe destination path
            $destinationPath = Join-Path -Path $TargetDirectory -ChildPath $safeFileName
        
            # Create a temporary directory and measure the time taken to extract the archive there
            Write-Output "[$archive.FullName]"
            $tempDestinationPath = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
            New-Item -Path $tempDestinationPath -ItemType Directory | Out-Null
            $duration = Measure-Command {
                # Extract to a temporary folder first
                Expand-Archive -Path $archive.FullName -DestinationPath $tempDestinationPath -Force
                # Output message before moving the items
                Write-Output "Moving extracted items from temporary directory to final destination [$destinationPath]"
                # Move the extracted content to the final destination with verbosity
                

                # Get the list of files to move
                $filesToMove = Get-ChildItem -Path $tempDestinationPath

                $totalFiles = $filesToMove.Count
                $currentFile = 0

                foreach ($file in $filesToMove) {
                    $currentFile++
                    $percentComplete = ($currentFile / $totalFiles) * 100

                    # Display progress
                    Write-Progress -Activity "Moving files" -Status "Moving $($file.Name)" -PercentComplete $percentComplete

                    # Move the file
                    Move-Item -Path $file.FullName -Destination $destinationPath -Force
                }

                # Clear the progress bar
                Write-Progress -Activity "Moving files" -Completed

                # Remove .zip from the folder name if present
                $finalDestinationPath = $destinationPath -replace '\.zip$', ''
                if ($finalDestinationPath -ne $destinationPath) {
                    Rename-Item -Path $destinationPath -NewName $finalDestinationPath
                }
                [int]$totalArchiveCount++
            }
            Remove-Item -Path $tempDestinationPath -Recurse -Force
            # Output message after moving the items
            Write-Output "Completed moving items to [$destinationPath]"
            
            # Write the result
            Write-Output "Extracting [`"$safeFileName`"] to [`"$destinationPath`"] took [$($duration.TotalSeconds)] seconds."

            # If it is a .zip file, delete it once extracted
            if ($archive.FullName -like '*.zip') {
                Remove-Item -Path $archive.FullName -Force
                Write-Output "Deleted [`"$safeFileName`"] from [`"$SourceDirectory`"]"
            }
        }
    } catch {
        Write-Error "Failed to complete with the following exception: [$($_.Exception.Message)]"
    } finally {
        # Output how many we handled
        if ($totalArchiveCount -eq 1) {
            Write-Output "Completed the process for [$($totalArchiveCount)] archive file."
        } else {
            Write-Output "Completed the process for [$($totalArchiveCount)] archive files."
        }
    }
}

$expandArchiveSplat = @{
    SourceDirectory = "C:\Users\dean\Downloads\Packs to Process"
    TargetDirectory = "\\CLEARBOOK\Games\ITGMania\Songs"
}

Expand-ArchiveFiles @expandArchiveSplat
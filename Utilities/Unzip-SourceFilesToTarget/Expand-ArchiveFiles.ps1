function Expand-ArchiveFiles {
    param(
        [string]$SourceDirectory,
        [string]$TargetDirectory
    )

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
        # Here, instead of creating a folder for each archive, 
        # we use the TargetDirectory directly
        $destinationPath = $TargetDirectory
        
        # Extract the archive to the target path
        Expand-Archive -Path $archive.FullName -DestinationPath $destinationPath -Force
        Write-Output "Extracted `"$($archive.Name)`" to `"$destinationPath`""
        Remove-Item -Path $archive -Force
        Write-Output "Deleted `"$($archive.Name)`" from `"$SourceDirectory`""
    }
}


Expand-ArchiveFiles -SourceDirectory "C:\Users\dean\Downloads\Packs" -TargetDirectory "\\CLEARBOOK\Games\ITGMania 0.7.0\Songs"

# Todo:
# Enable .rar files
# Fix Delete function

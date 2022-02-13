<#
Opening a File

    - Before we can read the contexts of the file, we must tell PowerShell which file we are going to work with and what we will be doing with the file
    - Get-Content opens the file in our interactive terminal
    - Invoke-Item opens the file in the shell
#>

$fhand = Get-Content -Path "C:\Users\me\OneDrive\PowerShell Scripts\Concepts\mbox-short.txt"
$fhand
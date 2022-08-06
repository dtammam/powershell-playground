PowerShell Modules in a Nutshell
=====================

I did some digging and figured out how Powershell Modules work. To explain it, I'll use the shell of the directories in this project. In so many words...

Conceptually:
-------------
- PowerShell modules are .psm1 format
- PowerShell manifests are .psd1 format... and are optional
- PowerShell modules are imported in a primary script
- PowerShell modules share global variables with the scripts that call it
- PowerShell modules can be called like *Import-Module -Name "$($PSScriptRoot)\ModuleName" -Force* and not need the module to be on the users' system within Documents... making it truly portable
- Module manifests allow for version controlling and other really cool attributes that can be controlled pre-execution

Tactically:
-------------
1. Start with an initial project (*ModuleCom*)
2. Create a sub-folder that will be the name of the module (*CommonUtilties*)
3. Create a sub-folder in that for your functions (*Functions*)
3. Create the .psm1 file which will call all functions within your function directory (*CommonUtilities.psm1*)
4. Create your actual functions as independent scripts within your functions directory. Use the .SYNOPSIS formatted commenting to empower users to leverage Get-Help (*Write-Event* and *Write-Log*)
5. Create your .psd1 file which is the manifest itself. You can do so by New-ModuleManifest (*CommonUtilities.psd1*)
6. Write your actual script, importing the modules and getting the commands (*ModuleCom.ps1*)

Resources:
-------------
If you'd like to see how they're actually used, check the files in this repo. It's a fully functional project that can be downloaded, executed and tweaked as a proof-of-concept.

I got **a lot** of value from the following resources:
1. [Kamil Pro's breakdown on YouTube](https://www.youtube.com/watch?v=xPQq0ui8j78 "PowerShell Module and Manifest- create and configure your tools")
2. [Bryan Cafferky's breakdown on YouTube](https://www.youtube.com/watch?v=AgCRjWRliwE "PowerShell Module 5: Creating Custom PowerShell Modules")
3. [Official Microsoft documentation on their site](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7.2 "How to Write a PowerShell Script Module")
4. [Tutorial.md's explanation of .md files (lol)](https://agea.github.io/tutorial.md/ "https://agea.github.io/tutorial.md/")

![I'm doing stuff and things!](https://i.pinimg.com/originals/37/f8/ed/37f8ed7686f5342ed76ef3df09e602d9.png)
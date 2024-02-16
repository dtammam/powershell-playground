#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

run PlusToCopyScreen.exe
run SlashToCopyScreen.exe
run SpacebarToResetAllPegasus.exe
run audiocontrols.bat
run TildeToRebootMachine.exe
run F2ToKioskModeAndReboot.exe
run F3ToAdminModeAndReboot.exe
Run, powershell.exe -WindowStyle Minimized -File C:\Pegasus\RestartiCloudLoop.ps1
Sleep 5000
run pegasus-fe.exe

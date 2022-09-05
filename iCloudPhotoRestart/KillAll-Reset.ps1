Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
Stop-Process -Name spice -ErrorAction SilentlyContinue
Stop-Process -Name StepMania -ErrorAction SilentlyContinue
Stop-Process -Name mame -ErrorAction SilentlyContinue
Stop-Process -Name mame2lit -ErrorAction SilentlyContinue
Stop-Process -Name outfox -ErrorAction SilentlyContinue
Stop-Process -Name gslauncher -ErrorAction SilentlyContinue
Stop-Process -Name ITGMania -ErrorAction SilentlyContinue
Stop-Process -Name cmd -ErrorAction SilentlyContinue
Stop-Process -Name explorer -ErrorAction SilentlyContinue
Stop-Process -Name OpenITG-PC -ErrorAction SilentlyContinue
Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue	
Stop-Process -Name cmd -ErrorAction SilentlyContinue -Force
Stop-Process -Name timeout -ErrorAction SilentlyContinue	
Stop-Process -Name notepad -ErrorAction SilentlyContinue -Force
Stop-Process -Name notepad++ -ErrorAction SilentlyContinue -Force
Stop-Process -Name regedit -ErrorAction SilentlyContinue -Force
Stop-Process -Name mmc -ErrorAction SilentlyContinue -Force
Get-Process | Where-Object { $_.MainWindowTitle -like '*Restart iCloud Loop' } | Stop-Process -ErrorAction SilentlyContinue -Force

Start-Process PowerShell C:\Pegasus\RestartiCloudLoop.ps1 -WindowStyle Minimized
Start-Process C:\pegasus\pegasus-fe.exe
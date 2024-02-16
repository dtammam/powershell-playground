Function Main {
	Remove-Module -Name .\CommonModules
	Import-Module -Name .\CommonModules.psm1
	Get-Command -Module CommonModules

	Write-Logs
}
Main
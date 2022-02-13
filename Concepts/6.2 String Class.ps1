<#
String Class

	- PowerShell has a number of string functions
    - These functions are already built into every string - we invoke them by appending the function to the string variable
	- These functions do not modify the original string, instead they return a new string that has been altered
	- Methods, such as .lower() can be found by referencing the String class - https://docs.microsoft.com/en-us/dotnet/api/system.string?view=net-6.0#methods
#>

$greet = 'Hello Bob'
$zap = $greet.ToLower()
$zap
$greet
'Hi There'.ToLower()
function privateFunction (
	[Parameter(Mandatory=$false)]
	[string]$string = "some string") {
	Write-Host "This is a private function that isn't exported"
	Write-Output "You entered $string"
}

function Get-MyModuleStringFromPrivate {
	Write-Host "This is a public function that should be exported"
	privateFunction "test"
}

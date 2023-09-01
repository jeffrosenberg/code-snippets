function Get-MyModuleStringFromPrereq {
	$prereq = Get-MyModulePrereq
	Write-Host $prereq

	Write-Output "The prereq function returned: '$prereq'"
}

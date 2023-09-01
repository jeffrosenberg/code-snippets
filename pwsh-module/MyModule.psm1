#Get function definition files.
$srcFiles = @( Get-Item -Path "$PSScriptRoot/src/MyModulePreqFunctions.ps1" ) # Other files have a dependency on this
$srcFiles += @( Get-ChildItem -Path "$PSScriptRoot/src/*.ps1" -Exclude "MyModulePreqFunctions.ps1" -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in $srcFiles)
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Only export members following the PowerShell convention of Verb-<Prefix>Noun
# Functions that appear in camelCase are private
Export-ModuleMember -Function *-MyModule*
# PowerShell

## Structure

### Function structure
```powershell
# Accept parameters
Function Do-Thing {
    Param
    (
      [Parameter(Mandatory=$true, Position=1)][String]$FirstParam, # Positional parameters
      [Parameter(Mandatory=$true, Position=2)][String]$SecondParam,
      [Parameter[switch]$HasBooleanValue, # True if supplied, false if not
      [Parameter(Mandatory=$false)][String] $DefaultParam = "Default", # Default parameter value
      [Parameter(Mandatory=$false)][Hashtable]$SplatParam
    )
}
```

### Module structure

A few good docs about creating a PowerShell module:
- https://learn.microsoft.com/en-us/powershell/scripting/developer/module/understanding-a-windows-powershell-module
- https://learn.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
- https://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/

For an example, see `pwsh-module/`
Instantiate that module using:

```powershell
Import-Module ./pwsh-module/MyModule.psd1
```

## String formatting

Lots of options and good explanation [here](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions).

## Remote execution

```powershell
Invoke-Command -ComputerName $machineName -ScriptBlock { Write-Host "This will actually run on $machineName" }
```

## CLI commands

```powershell
# Create a symbolic link
New-Item -ItemType SymbolicLink -Path "settings.json" -Target "$Env:DOTFILES/VSCode/settings.json"
```

## Common script boilerplate
```powershell
# Get the path of the script
$ScriptPath = $PSCommandPath;
$ScriptFolder = Split-Path -Path $PSCommandPath -Parent;

# Wait for user input
Read-Host "Do a thing, then press any key to continue"
$test = Read-Host "Enter a value, then press enter"
Write-Host $test

# Manage error responses
$MyVar = Get-Item -Path "$MyPath" -ErrorAction SilentlyContinue # Ignore errors
if ($null -eq $MyVar) { $MyVar = "/my/alternate/path" }

try {
   $MyVar = Get-Item -Path "$MyPath" -ErrorAction Stop # Force non-terminating errors to trigger the catch block
}
catch {
   Write-Host "Whoops!"
}

# Set output levels

# Must set these to strings, i.e. "Continue" vs Continue
$DebugPreference = "Continue" # Show the debug stream
$DebugPreference = "SilentlyContinue" # Hide the debug stream
$DebugPreference = "Stop" # Stop executing and print the message -- this is uncommon to use for Debug
$DebugPreference = "Inquire" # Print the message and ask whether the user wants to continue

<#
Similar preference variables:

$ErrorActionPreference
$InformationPreference
$ProgressPreference
$VerbosePreference
$WarningPreference

For more details:
Preference variables: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables
Output streams:       https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams
#>
```

## Utility functions
```powershell
# Measure elapsed time with a stopwatch object
# via: https://pscustomobject.github.io/powershell/howto/Measure-Script-Time/

# Instantiate and start a new stopwatch
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Most of the functionality we want lives inside `stopwatch.Elapsed`:
> $stopwatch.Elapsed | Get-Member -Type property

<#
   TypeName: System.TimeSpan

Name              MemberType Definition
----              ---------- ----------
Days              Property   int Days {get;}
Hours             Property   int Hours {get;}
Milliseconds      Property   int Milliseconds {get;}
Minutes           Property   int Minutes {get;}
Seconds           Property   int Seconds {get;}
Ticks             Property   long Ticks {get;}
TotalDays         Property   double TotalDays {get;}
TotalHours        Property   double TotalHours {get;}
TotalMilliseconds Property   double TotalMilliseconds {get;}
TotalMinutes      Property   double TotalMinutes {get;}
TotalSeconds      Property   double TotalSeconds {get;}
#>

Write-Host "Executed profile in $($stopwatch.Elapsed.TotalMilliseconds) milliseconds"
$stopwatch.Stop()
```
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
      [Parameter][switch]$HasBooleanValue, # True if supplied, false if not
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

## Collections

Arrays, hashtables, etc.

### Hash tables and splatting

See:
- https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables
- https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting

```powershell
# Basic syntax for creating a hashtable: use @
# @{ <name> = <value>; [<name> = <value> ] ...}
# [ordered]@{ <name> = <value>; [<name> = <value> ] ...}
$hash = @{ Number = 1; Shape = "Square"; Color = "Blue"}
$hash = @{ 
            Number = 1
            Shape = "Square"
            Color = "Blue"
         }
```

### Splitting a string
```
# Create an array by splitting a string
> $str = "Test1,Test2,Test3"
> $split = $str.Split(',')
> $split
Test1
Test2
Test3

> $test1, $test2, $test3 = $str.Split(',')
> $test1
Test1
> $test2
Test2
> $test3
Test3

> $test4, $test5 = $str.Split(',')
> $test4
Test1
> $test5
Test2
Test3
```

## String formatting

Lots of options and good explanation [here](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-string-substitutions).

```powershell
# Simple variable substitution:
$message = "Hello, $first $last."

# Command substitution:
$message = "Date: $(Get-Date)"

# Format string:
'Hello, {0} {1}.' -f $first, $last

# Here-string with embedded variables:
$vsCodeTemplate = @"
{
	"folders": [
		{
			"path": "$targetFolderName"
		},
		{
			"path": "$Env:AREAS/CD/_repos/utils"
		},
		{
			"path": "$HOME/Documents/Working"
		}
	]
}
"@
```

## Remote execution

```powershell
Invoke-Command -ComputerName $machineName -ScriptBlock { Write-Host "This will actually run on $machineName" }
```

## CLI commands

```powershell
# Create a symbolic link
New-Item -ItemType SymbolicLink -Path "settings.json" -Target "$Env:DOTFILES/VSCode/settings.json"
```

### Find files on the filesystem (ls / Get-ChildItem)

Note that most of the snippets below can be combined / piped / etc.

```powershell
# Search recursively for a file
Get-ChildItem -Path C:\my\path -Filter <filename_pattern> -Recurse -ErrorAction SilentlyContinue -Force

# Filter based on the last-modified date
Get-ChildItem -Path C:\my\path -Filter <filename_pattern> | Where-Object { $_.LastWriteTime -lt $((Get-Date).AddDays(-7)) }

# Remove files based on a filter
# Use `-Confirm` if you want to double-check items for safety
Get-ChildItem -Path C:\my\path -Filter <filename_pattern> | Remove-Item -Confirm
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
```

### Output formats

```powershell
# Select-Object to reduce (or expand!) the number of properties displayed
Get-ChildItem | Select-Object -Property Name, CreationTime
Get-ChildItem | Select-Object -Property *

# Format-<FormatStyle> to alter how multiple results are displayed
Get-Command -Verb Format -Module Microsoft.PowerShell.Utility
Format-List  # Displays each item and its selected (or default) properties as a set of lines
Format-Table # Displays each item and its selected (or default properties) on one line
Format-Wide  # Displays a single property for each item, in multiple columns

# Format commands also let you select properties
Get-ChildItem | Format-Table -Property Name, CreationTime
```

### Set output levels

```powershell
# Must set these to strings, i.e. "Continue" vs Continue
$DebugPreference = "Continue" # Show the debug stream
$DebugPreference = "SilentlyContinue" # Hide the debug stream
$DebugPreference = "Stop" # Stop executing and print the message -- this is uncommon to use for Debug
$DebugPreference = "Inquire" # Print the message and ask whether the user wants to continue
```

Similar preference variables:

- `$ErrorActionPreference`
- `$InformationPreference`
- `$ProgressPreference`
- `$VerbosePreference`
- `$WarningPreference`

For more details:
Preference variables: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables
Output streams:       https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams

## Power management

```powershell
# Restart a computer
Restart-Computer [-ComputerName Computer1,Computer2]

# Get the last boot time
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
# Uptime in minutes
$((get-date) – (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).Minutes
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
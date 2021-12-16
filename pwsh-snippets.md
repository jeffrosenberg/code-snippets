# PowerShell

## Function structure
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

## Common script boilerplate
```powershell
# Get the path of the script
$ScriptPath = $PSCommandPath;
$ScriptFolder = Split-Path -Path $PSCommandPath -Parent;

# Wait for user input
Read-Host "Do a thing, then press any key to continue"

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
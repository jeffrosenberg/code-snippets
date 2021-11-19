# PowerShell

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
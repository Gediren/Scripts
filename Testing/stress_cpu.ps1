<# DESCRIPTION
    Developer:  Matt Waldeck
    Date:       07-04-2019
    Language:   PowerShell
    Purpose:    Stresses CPU to 100% using basic math jobs.
    Last Edit:  07-04-2019
    Version:    v1.0.0
#>

# RAM in box
$box=get-WMIobject Win32_ComputerSystem
$Global:physMB=$box.TotalPhysicalMemory / 1024 /1024

# PerfMon counters
$Global:psPerfCPU = new-object System.Diagnostics.PerformanceCounter("Processor","% Processor Time","_Total")
$Global:psPerfMEM = new-object System.Diagnostics.PerformanceCounter("Memory","Available Mbytes")
$psPerfCPU.NextValue() | Out-Null
$psPerfMEM.NextValue() | Out-Null

# Timer
$Global:psTimer   = New-Object System.Timers.Timer
$psTimer.Interval = 1500

# Every timer interval, update the CMD shell window with RAM and CPU info.
Register-ObjectEvent -InputObject $psTimer -EventName Elapsed -Action {
[int]$ram = $physMB - $psPerfMEM.NextValue()
[int]$cpu = $psPerfCPU.NextValue()
$Host.ui.rawui.WindowTitle = "$($Host.Name) | Processor: $cpu%, Memory: $ram MB"
} | Out-Null
$psTimer.start()

# Now we can start stressing the processor
$coreCount = Get-WmiObject win32_processor | Select-Object -ExpandProperty NumberOfLogicalProcessors

Write-Output "Warning: This may affect system performance."
Write-Output "Running on $coreCount threads..."

# For each item in $coureCount, start a job.
foreach ($_ in 1..$coreCount){
    Start-Job -ScriptBlock{
    $result = 1
        foreach ($number in 1..2147483647){
            $result = $result * $number
        }
    }
}

Wait-Job *
Clear-Host
Receive-Job *
Remove-Job *
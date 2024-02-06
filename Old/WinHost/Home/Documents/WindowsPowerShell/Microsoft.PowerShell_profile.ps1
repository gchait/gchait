$env:VAGRANT_EXPERIMENTAL = "disks"

$calcMem = [math]::Ceiling((Get-WmiObject -Class Win32_ComputerSystem | `
    Select-Object -ExpandProperty TotalPhysicalMemory) / 1GB)

$calcCpu = (Get-WmiObject -Class Win32_Processor | `
    Measure-Object -Property NumberOfCores -Sum).Sum

$env:GIT_NAME = "Guy Chait"
$env:GIT_EMAIL = ""

$env:DISK_GB = 200
$env:PORT_TCP = 8080

$env:MEMORY = if ($calcMem -gt 1) { $calcMem / 4 * 1024 } else { 1024 }
$env:CPUS = if ($calcCpu -gt 1) { $calcCpu / 2 } else { 1 }

New-Alias v vagrant

function ntex {
    mkdir "$args"
    
    if ($?) {
        Copy-Item -Path $HOME\gchait\WinHost\LatexExample\* `
            -Destination .\$args\ -Recurse
    }
}

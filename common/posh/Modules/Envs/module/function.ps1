function functions {
    Get-ChildItem function:
}
function printenv {
    Get-ChildItem env:
}
function greps {
    Select-String -Encoding ansi @args
}
function which ([string]$command,[switch][Alias("a")]$all) {
    [System.Management.Automation.CommandInfo]$cmd = Get-Command $command
    if (!$all) { $cmd = $cmd | Select-Object -First 1 }
    $cmd.Path
}
function touch ([string]$fPath) {
    if (!(Test-Path -Path $fPath)) {
        New-Item -Path $fPath -ItemType File | Out-Null
    } else {
        (Get-Item -Path $fPath).LastWriteTime = Get-Date
    }
}


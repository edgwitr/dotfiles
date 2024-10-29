function which {
    param (
        [string]$command,
        [switch][Alias("a")]$all
    )

    [System.Management.Automation.CommandInfo]$cmd = Get-Command $command

    if (!$all) { $cmd = $cmd | Select-Object -First 1 }
    
    $cmd.Path

}
function touch {
    param(
        [string]$Path
    )

    if (!(Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType File | Out-Null
    } else {
        (Get-Item -Path $Path).LastWriteTime = Get-Date
    }
}
function functions {
    Get-ChildItem function:
}
function printenv {
    Get-ChildItem env:
}

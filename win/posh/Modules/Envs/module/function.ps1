function which {
    param (
        [string]$command,
        [switch][Alias("a")]$all
    )

    [System.Management.Automation.CommandInfo]$cmd = Get-Command $command

    if (!$all) { $cmd = $cmd | Select-Object -First 1 }
    
    $cmd.Path

}

function which {
    param (
        [string]$command,         # コマンド名を引数として受け取る
        [switch][Alias("a")]$all  # `-a`をエイリアスとして`-all`と同様の機能を持たせる
    )

    [System.Management.Automation.CommandInfo]$cmd = Get-Command $command

    if (!$all) { $cmd = $cmd | Select-Object -First 1 }
    
    $cmd.Path

}

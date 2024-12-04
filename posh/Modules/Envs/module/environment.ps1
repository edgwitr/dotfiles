$env:LANG = "en_US.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
$Env:XDG_CACHE_HOME = "$Env:USERPROFILE/.cache"
$Env:XDG_STATE_HOME = "$Env:USERPROFILE/.local/state"
$Env:XDG_DATA_HOME = "$Env:USERPROFILE/.local/share"
$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE/.config"

$Env:RUSTUP_HOME = "$Env:USERPROFILE/.local/rustup"
$Env:CARGO_HOME = "$Env:USERPROFILE/.local/cargo"
$Env:GOPATH = "$Env:USERPROFILE/.local/go"

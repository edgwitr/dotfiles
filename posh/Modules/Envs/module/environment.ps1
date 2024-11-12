$env:LANG = "C.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
$Env:XDG_CACHE_HOME = "$Env:USERPROFILE/.cache"
$Env:XDG_STATE_HOME = "$Env:USERPROFILE/.local/state"
$Env:XDG_DATA_HOME = "$Env:USERPROFILE/.local/share"
$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE/.config"

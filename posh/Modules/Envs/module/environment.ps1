$env:LANG = "en_US.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
if($Env:USERPROFILE -eq $null) {
  $homedir = $Env:HOME
} else {
  $homedir = $Env:USERPROFILE
}
$Env:XDG_CACHE_HOME = "$homedir/.cache"
$Env:XDG_STATE_HOME = "$homedir/.local/state"
$Env:XDG_DATA_HOME = "$homedir/.local/share"
$Env:XDG_CONFIG_HOME = "$homedir/.config"

$Env:RUSTUP_HOME = "$homedir/.local/rustup"
$Env:CARGO_HOME = "$homedir/.local/cargo"
$Env:GOPATH = "$homedir/.local/go"

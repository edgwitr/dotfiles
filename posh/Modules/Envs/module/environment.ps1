$env:LANG = "en_US.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
if($null -eq $env:HOME) {
  $env:HOME = $env:USERPROFILE
}
$Env:XDG_CACHE_HOME = "$env:HOME/.cache"
$Env:XDG_STATE_HOME = "$env:HOME/.local/state"
$Env:XDG_DATA_HOME = "$env:HOME/.local/share"
$Env:XDG_CONFIG_HOME = "$env:HOME/.config"
$env:SANDBOX = "$env:HOME/.local/dotfiles/sandbox"

$Env:RUSTUP_HOME = "$env:HOME/.local/rustup"
$Env:CARGO_HOME = "$env:HOME/.local/cargo"
$Env:GOPATH = "$env:HOME/.local/go"

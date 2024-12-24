$env:LANG = "en_US.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
if($null -eq $env:HOME) {
  $env:HOME = $env:USERPROFILE
}
$env:XDG_CACHE_HOME = "$env:HOME/.cache"
$env:XDG_STATE_HOME = "$env:HOME/.local/state"
$env:XDG_DATA_HOME = "$env:HOME/.local/share"
$env:XDG_CONFIG_HOME = "$env:HOME/.config"
$env:SANDBOX = "$env:HOME/.local/dotfiles/sandbox"

$env:RUSTUP_HOME = "$env:HOME/.local/rustup"
$env:CARGO_HOME = "$env:HOME/.local/cargo"
$env:GOPATH = "$env:HOME/.local/go"

$env:EDITOR = "nvim"

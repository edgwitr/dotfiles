$env:LANG = "en_US.UTF-8"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
if($null -eq $env:HOME) {
  $env:HOME = $env:USERPROFILE
}

$env:GITREPOROOT = [System.IO.Path]::Combine($HOME, ".local","git-repositories")
$env:XDG_CACHE_HOME = [System.IO.Path]::Combine($env:HOME, ".cache")
$env:XDG_CONFIG_HOME = [System.IO.Path]::Combine($env:HOME, ".config")
$env:XDG_STATE_HOME = [System.IO.Path]::Combine($env:HOME, ".local", "state")
$env:XDG_DATA_HOME = [System.IO.Path]::Combine($env:HOME, ".local", "share")

$env:RUSTUP_HOME = [System.IO.Path]::Combine($env:HOME, ".local", "rustup")
$env:CARGO_HOME = [System.IO.Path]::Combine($env:HOME, ".local", "cargo")
$env:GOPATH = [System.IO.Path]::Combine($env:HOME, ".local", "go")

$env:EDITOR = "nvim"

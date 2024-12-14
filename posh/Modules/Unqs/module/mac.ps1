Set-Abbr remac 'darwin-rebuild switch --flake ~/.local/dotfiles/#' -NoSpaceAfter
if (Test-Path /opt/homebrew/bin/brew) {
  /opt/homebrew/bin/brew shellenv | Invoke-Expression
}

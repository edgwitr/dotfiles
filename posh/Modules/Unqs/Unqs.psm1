$modDir = Join-Path -Path $PSScriptRoot -ChildPath "module"
if ($env:OSTYPE -eq "win") {
  . "$modDir/win.ps1"
} else {
  . "$modDir/unix.ps1"
  if ($env:OSTYPE -eq "mac") {
    . "$modDir/mac.ps1"
  } elseif ($env:OSTYPE -eq "linux") {
    . "$modDir/linux.ps1"
  }
}

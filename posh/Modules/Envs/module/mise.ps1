if ($env:OSTYPE -eq "win") {
  $env:PATH = $env:PATH + ";" + "$env:USERPROFILE\AppData\Local\mise\shims"
}

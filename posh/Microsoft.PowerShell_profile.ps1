$env:OSTYPE = ""
$env:OSINFO = ""
if ($PSVersionTable.PSEdition -eq "Desktop") {
  $env:OSTYPE = "win"
  $env:OSINFO = "posh"
} else {
  if ($PSVersionTable.OS -like 'Darwin*') {
    $env:OSTYPE = "mac"
  } elseif ($PSVersionTable.OS -like 'Microsoft*') {
    $env:OSTYPE = "win"
    $env:OSINFO = "pwsh"
  } else {
    $env:OSTYPE = "linux"
    if ($null -ne $env:WSL_DISTRO_NAME) {
      $env:OSINFO = "wsl"
    }
  }
}
Import-Module Abbr
Import-Module Cmds
Import-Module Cmps
Import-Module Envs
Import-Module Unqs
if ( Test-Path $PSScriptRoot/local.ps1 ) { . $PSScriptRoot/local.ps1 }

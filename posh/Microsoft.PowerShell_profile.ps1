$global:osEnv = ""
if ($PSVersionTable.PSEdition -eq "Desktop") {
  $global:osEnv = "win"
} else {
  if ($PSVersionTable.OS -like 'Darwin*') {
    $global:osEnv = "mac"
  } elseif ($PSVersionTable.OS -like 'Microsoft*') {
    $global:osEnv = "win"
  } else {
    $global:osEnv = "linux"
  }
}
Import-Module Abbr
Import-Module Cmds
Import-Module Cmps
Import-Module Envs
if ( Test-Path $PSScriptRoot/local.ps1 ) { . $PSScriptRoot/local.ps1 }

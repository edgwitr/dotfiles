$global:winEnv = ($PSVersionTable.PSEdition -eq "Desktop" -or $IsWindows -eq $true)
Import-Module Abbr
Import-Module Cmds
Import-Module Cmps
Import-Module Envs
if ( $global:winEnv ) {
  Import-Module Wins
} else {
  Import-Module Unxs
}
if ( Test-Path $PSScriptRoot/local.ps1 ) { . $PSScriptRoot/local.ps1 }

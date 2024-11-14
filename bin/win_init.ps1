if (!($PSVersionTable.PSEdition -eq "Desktop" -or $IsWindows -eq $true)) { return }

mkdir -p "$Env:USERPROFILE\.cache"
mkdir -p "$Env:USERPROFILE\.config"
mkdir -p "$Env:USERPROFILE\.local\state"
mkdir -p "$Env:USERPROFILE\.local\share"

$dotroot = Split-Path -Path $PSScriptRoot -Parent

$posh = "$dotroot\posh"
New-Item -ItemType Junction -Target $posh -Path "$env:USERPROFILE\Documents\WindowsPowerShell"
New-Item -ItemType Junction -Target $posh -Path "$env:USERPROFILE\Documents\PowerShell"

New-Item -ItemType Junction -Target "$dotroot\git" -Path "$Env:USERPROFILE\.config\git"
New-Item -ItemType Junction -Target "$dotroot\nvim" -Path "$Env:USERPROFILE\.config\nvim"

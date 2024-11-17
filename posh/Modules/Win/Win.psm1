if (!($PSVersionTable.PSEdition -eq "Desktop" -or $IsWindows -eq $true)) { return }
$modDir = Join-Path -Path $PSScriptRoot -ChildPath "module"
Get-ChildItem -Path $modDir -Filter *.ps1 | ForEach-Object { . $_.FullName }

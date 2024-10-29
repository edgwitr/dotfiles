$wposh = "$env:USERPROFILE\Documents\WindowsPowerShell"
$cposh = "$env:USERPROFILE\Documents\PowerShell"
$posh = "$dotroot\common\posh"
New-Item -ItemType SymbolicLink -Target $posh -Path $wposh
New-Item -ItemType SymbolicLink -Target $posh -Path $cposh

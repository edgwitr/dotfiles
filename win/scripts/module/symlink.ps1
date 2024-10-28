$wposh = "$env:USERPROFILE\Documents\WindowsPowerShell"
$cposh = "$env:USERPROFILE\Documents\PowerShell"
New-Item -ItemType SymbolicLink -Path ..\..\posh -Target $wposh
New-Item -ItemType SymbolicLink -Path ..\..\posh -Target $cposh

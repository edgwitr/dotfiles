$wposh = "$env:USERPROFILE\Documents\WindowsPowerShell"
$cposh = "$env:USERPROFILE\Documents\PowerShell"
New-Item -ItemType SymbolicLink -Path .\win\posh -Target $wposh
New-Item -ItemType SymbolicLink -Path .\win\posh -Target $cposh

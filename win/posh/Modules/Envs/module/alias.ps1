function _printenv {
    Get-ChildItem env:
}
Set-Alias -Name printenv -Value _printenv

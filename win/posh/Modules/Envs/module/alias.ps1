function _printenv {
    Get-ChildItem env:
}
Set-Alias -Name printenv -Value _printenv

Set-Alias grep "Select-String"
function _greps {
    Select-String -Encoding default @args
}
Set-Alias greps _greps
function _touch {
    param(
        [string]$Path
    )

    if (!(Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType File | Out-Null
    } else {
        (Get-Item -Path $Path).LastWriteTime = Get-Date
    }
}
Set-Alias touch _touch

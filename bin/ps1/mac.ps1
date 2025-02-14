param(
    [Parameter()][switch]$Restore
)

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Require admin"
    return
}
$keyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$keyName = "Scancode Map"

if ($Restore) {
    # remove-keymap
    if (Get-ItemProperty -Path $keyPath -Name $keyName) {
        Remove-ItemProperty -Path $keyPath -Name $keyName
        Write-Output "Remove keyMap"
    }
} else {
    # add-keymap
    $binaryData = [byte[]](
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x03, 0x00, 0x00, 0x00,

        # 0x3A, 0x00, 0x1D, 0xE0, # capslock <- RCtrl
        # 0x64, 0x00, 0x3A, 0x00, # F13 <- capslock

        # 0x5B, 0xE0, 0x1D, 0x00, # LWin <- LCtrl
        # 0x38, 0x00, 0x5B, 0xE0, # LAlt <- LWin
        # 0x1D, 0x00, 0x38, 0x00, # LCtrl <- LAlt

        # for powertoys
        0x1D, 0xE0, 0x3A, 0x00, # RCtrl <- capslock
        0x38, 0x00, 0x70, 0x00, # LAlt <- kana

        0x00, 0x00, 0x00, 0x00
    )

    Set-ItemProperty -Path $keyPath -Name $keyName -Value $binaryData -Type Binary
    Write-Output "Add keyMap"
}

$response = Read-Host "Reboot? [Y/N]"
if ($response -eq "Y") {
    Restart-Computer -Force
}

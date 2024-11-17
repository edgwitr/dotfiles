$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$backupValue = Get-ItemProperty -Path $registryPath -Name "Scancode Map" -ErrorAction SilentlyContinue
if ($backupValue) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$env:USERPROFILE\Desktop\KeyboardLayout_Backup_$timestamp.reg"
    reg export "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" $backupPath
    Write-Host "Created backup: $backupPath"
}

$binaryData = [byte[]](
    0x00, 0x00, 0x00, 0x00,  # header1
    0x00, 0x00, 0x00, 0x00,  # header2
    0x03, 0x00, 0x00, 0x00,  # increment entry-count
    0x64, 0x00, 0x3a, 0x00,  # F13(64h)←capslock(3ah)
    0x65, 0x00, 0x38, 0x00,  # F14(65h)←LAlt(38h)
    0x00, 0x00, 0x00, 0x00   # endian
)
Set-ItemProperty -Path $registryPath -Name "Scancode Map" -Value $binaryData -Type Binary

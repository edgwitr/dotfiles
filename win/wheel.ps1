# Get all mouse devices
$mouseDevices = Get-WmiObject Win32_PointingDevice
foreach ($mouse in $mouseDevices) {
    $deviceID = $mouse.DeviceID
    $fpath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$deviceID\Device Parameters"
    Set-ItemProperty -Path $fpath -Name "FlipFlopWheel" -Value 1
    Write-Output "Changed wheel direction for device '$($mouse.Name)'"
}

$version = "15.0"
$imePath = "HKCU:\Software\Microsoft\IME\$version\IMEJP\MSIME"

# set value
if (Test-Path $imePath) {
    Set-ItemProperty -Path $imePath -Name "IsKeyAssignmentEnabled" -Value 1 -Type DWord
    Set-ItemProperty -Path $imePath -Name "KeyAssignmentHenkan" -Value 0 -Type DWord
    Set-ItemProperty -Path $imePath -Name "KeyAssignmentMuhenkan" -Value 1 -Type DWord

    Write-Host "Update registry-value: $imePath" -ForegroundColor Green
} else {
    Write-Host "Can't find the path: $imePath" -ForegroundColor Red
}

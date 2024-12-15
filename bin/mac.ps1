# function Set-Macenv {
    param(
        [Parameter()][switch]$Restore
    )

    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Require admin"
        return
    }
    $keyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
    $keyName = "Scancode Map"
    $mouseValue = 1
    $ahkPath = Join-Path -Path ([Environment]::GetFolderPath('Startup')) -ChildPath "adapt.ahk"
    $ahkValue = "$env:USERPROFILE\.local\dotfiles\bin\adapt.ahk"

    if ($Restore) {
        $mouseValue = 0
        # remove-keymap
        if (Get-ItemProperty -Path $keyPath -Name $keyName -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $keyPath -Name $keyName
            Write-Output "Remove keyMap"
        }
        if (Test-Path $ahkPath) {
            Remove-Item -Path $ahkPath
            Write-Output "Remove ahk-startup"
        }
    } else {
        # add-keymap
        $binaryData = [byte[]](
            0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00,
            0x07, 0x00, 0x00, 0x00,

            0x1D, 0xE0, 0x70, 0x00, # RCtrl <- kana
            0x3A, 0x00, 0x1D, 0xE0, # capslock <- RCtrl
            0x64, 0x00, 0x3A, 0x00, # F13 <- capslock

            0x5B, 0xE0, 0x1D, 0x00, # LWin <- LCtrl
            0x38, 0x00, 0x5B, 0xE0, # LAlt <- LWin
            0x1D, 0x00, 0x38, 0x00, # LCtrl <- LAlt

            0x00, 0x00, 0x00, 0x00
        )

        Set-ItemProperty -Path $keyPath -Name $keyName -Value $binaryData -Type Binary
        Write-Output "Add keyMap"

        if (-not (Test-Path $ahkPath)) {
            New-Item -ItemType SymbolicLink -Target $ahkValue -Path $ahkPath
            Write-Output "Create sym-link"
        }
    }

    # Get all mouse devices
    Get-PnpDevice -Class Mouse | Where-Object { $_.Status -eq "OK" } | ForEach-Object {
        $deviceID = $_.DeviceID
        $fpath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$deviceID\Device Parameters"
        Set-ItemProperty -Path $fpath -Name "FlipFlopWheel" -Value $mouseValue
        Write-Output "Changed wheel direction for device '$($_.Name)'"
    }

    $response = Read-Host "Reboot? [Y/N]"
    if ($response -eq "Y") {
       Restart-Computer -Force
    }

# }

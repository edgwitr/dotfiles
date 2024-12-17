[CmdletBinding()]
Param(
  [Parameter(ValueFromPipeline = $true)]
  [string[]]$argValue
)

BEGIN {
  $allOptions = @()
}

PROCESS {
  if (-not $null -eq $argValue) {
    $argValue | ForEach-Object { $allOptions += $_ }
  }
}

END {
  if ($allOptions.Count -eq 0) {
    $allOptions = (Get-ChildItem -Path . -Recurse).FullName | ForEach-Object {
      $_.Replace((Get-Location).Path + [System.IO.Path]::DirectorySeparatorChar, "")
    }
  }

  # enable alternate screen buffer
  Write-Host -NoNewline ([char]0x1b + "[?1049h")

  # initialize variables
  $filteredOptions = $allOptions
  $selectedIndex = 0
  $inputStr = ""

  # draw function
  $DrawMenu = {
    param ($options, $selectedIndex, $inputStr)
    [Console]::Clear()
    Write-Host "Filter: $inputStr"
    Write-Host "Use Up/Down Arrow keys to navigate, Enter to select."
    Write-Host ""

    for ($i = 0; $i -lt $options.Count; $i++) {
      if ($i -eq $selectedIndex) {
        Write-Host -NoNewline ([char]0x1b + "[7m") # Reverse video mode
        Write-Host $options[$i]
        Write-Host -NoNewline ([char]0x1b + "[0m") # Reset formatting
      } else {
        Write-Host $options[$i]
      }
    }
    if ($options.Count -eq 0) {
      Write-Host "(No matches found)"
    }
  }

  # draw initial menu
  $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)

  # wait for key input
  while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    switch ($key.VirtualKeyCode) {
      # control
      224 {
        switch ($key.VirtualKeyCode) {
          # Ctrl+C
          67 {
            Write-Host -NoNewline ([char]0x1b + "[?1049l")
            exit
          }
          # Ctrl+N
          78 {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Ctrl+P
          80 {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
              if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Left Arrow
          37 {
            # Do nothing
          }
          # Up Arrow
          38 {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
              if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Right Arrow
          39 {
            # Do nothing
          }
          # Down Arrow
          40 {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          default {
            # Do nothing
          }
        }
      }
      # Left Arrow
      37 {
        # Do nothing
      }
      # Up Arrow
      38 {
        if ($filteredOptions.Count -gt 0) {
          $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
          if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
          $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
        }
      }
      # Right Arrow
      39 {
        # Do nothing
      }
      # Down Arrow
      40 {
        if ($filteredOptions.Count -gt 0) {
          $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
          $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
        }
      }
      # Backspace
      8 {
        if ($inputStr.Length -gt 0) {
          $inputStr = $inputStr.Substring(0, $inputStr.Length - 1)
          $fzInput = $inputStr -replace '(.)', '$1*' -replace '\*$', ''
          $filteredOptions = $allOptions.Where({ $_ -like "*$fzInput*" })
          $selectedIndex = 0
          $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
        }
      }
      # Enter
      13 {
        if ($filteredOptions.Count -gt 0) {
          Write-Host -NoNewline ([char]0x1b + "[?1049l")
          return $filteredOptions[$selectedIndex]
        }
      }
      # Esc
      27 {
        Write-Host -NoNewline ([char]0x1b + "[?1049l")
        exit
      }
      default {
        # add filter string
        if ($key.Character -match '\S') {
          $inputStr += $key.Character
          $fzInput = $inputStr -replace '(.)', '$1*' -replace '\*$', ''
          $filteredOptions = $allOptions.Where({ $_ -like "*$fzInput*" })
          $selectedIndex = 0
          $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
        }
      }
    }
  }
}

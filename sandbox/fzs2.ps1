[CmdletBinding()]
Param(
  [Parameter(ValueFromPipeline = $true)]
  [string[]]$argValue
)

BEGIN {
  $allOptions = @()
}

PROCESS {
  if ($argValue) {
    $argValue.foreach({ $allOptions += $_ })
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
  [Console]::TreatControlCAsInput = $true
  while ($true) {
    $key = [Console]::ReadKey($true)
    switch ($key.Modifiers) {
      Control {
        switch ($key.Key) {
          # Ctrl-C
          C {
            Write-Host -NoNewline ([char]0x1b + "[?1049l")
            return
          }
          # Ctrl-P
          P {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
              if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Ctrl-N
          N {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          default {
          }
        }
      }
      default {
        switch ($key.Key) {
          # Enter
          Enter {
            if ($filteredOptions.Count -gt 0) {
              Write-Host -NoNewline ([char]0x1b + "[?1049l")
              return $filteredOptions[$selectedIndex]
            }
          }
          # Up Arrow
          UpArrow {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
              if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Down Arrow
          DownArrow {
            if ($filteredOptions.Count -gt 0) {
              $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Backspace
          Backspace {
            if ($inputStr.Length -gt 0) {
              $inputStr = $inputStr.Substring(0, $inputStr.Length - 1)
              $fzInput = $inputStr -replace '(.)', '$1*' -replace '\*$', '' -replace '\?','`?'
              $filteredOptions = $allOptions.Where({ $_ -like "*$fzInput*" })
              $selectedIndex = 0
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
          # Escape
          Escape {
            Write-Host -NoNewline ([char]0x1b + "[?1049l")
            return
          }
          default {
            # add filter string
            if ($key.KeyChar -match '[a-zA-Z0-9!-/:-@[-`{-~]') {
              $inputStr += $key.KeyChar
              $fzInput = $inputStr -replace '(.)', '$1*' -replace '\*$', '' -replace '\?','`?'
              $filteredOptions = $allOptions.Where({ $_ -like "*$fzInput*" })
              $selectedIndex = 0
              $DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)
            }
          }
        }
      }
    }
  }
}

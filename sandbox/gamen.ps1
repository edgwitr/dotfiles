# オルタネイトバッファを有効化
Write-Host -NoNewline ([char]0x1b + "[?1049h")

# 初期選択肢
$allOptions = @("Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew")
$filteredOptions = $allOptions
$selectedIndex = 0
$inputStr = ""

# 画面描画関数
$DrawMenu = {
  param ($options, $selectedIndex, $inputStr)
  [Console]::Clear()
  Write-Host $options
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

# 初期画面描画
$DrawMenu.Invoke($filteredOptions, $selectedIndex, $inputStr)

# キー入力待機ループ
while ($true) {
  $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  switch ($key.VirtualKeyCode) {
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
        $inputStr = $inputStr.Substring(0, $input.Length - 1)
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
    # ^C
    3 {
      Write-Host -NoNewline ([char]0x1b + "[?1049l")
      exit
    }
    default {
      # 入力された文字をフィルタリング文字列に追加
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

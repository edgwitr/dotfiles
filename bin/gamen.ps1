# オルタネイトバッファを有効化
Write-Host -NoNewline "`e[?1049h"

try {
    # 初期選択肢
    $allOptions = @("Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew")
    $filteredOptions = $allOptions
    $selectedIndex = 0
    $input = ""

    # 画面描画関数
    $DrawMenu = {
        param ($options, $selectedIndex, $input)
        [Console]::Clear()
        Write-Host $options
        Write-Host "Filter: $input"
        Write-Host "Use Up/Down Arrow keys to navigate, Enter to select."
        Write-Host ""
        for ($i = 0; $i -lt $options.Count; $i++) {
            if ($i -eq $selectedIndex) {
                Write-Host $options[$i] -BackgroundColor White -ForegroundColor Black # 反転表示
            } else {
                Write-Host $options[$i]
            }
        }
        if ($options.Count -eq 0) {
            Write-Host "(No matches found)"
        }
    }

    # 初期画面描画
    $DrawMenu.Invoke($filteredOptions, $selectedIndex, $input)

    # キー入力待機ループ
    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        switch ($key.VirtualKeyCode) {
            38 { # Up Arrow
                if ($filteredOptions.Count -gt 0) {
                    $selectedIndex = ($selectedIndex - 1) % $filteredOptions.Count
                    if ($selectedIndex -lt 0) { $selectedIndex = $filteredOptions.Count - 1 }
                    DrawMenu $filteredOptions $selectedIndex $input
                }
            }
            40 { # Down Arrow
                if ($filteredOptions.Count -gt 0) {
                    $selectedIndex = ($selectedIndex + 1) % $filteredOptions.Count
                    DrawMenu $filteredOptions $selectedIndex $input
                }
            }
            8 { # Backspace
                if ($input.Length -gt 0) {
                    $input = $input.Substring(0, $input.Length - 1)
                    $fzInput = $input -replace '(.)', '$1*' -replace '\*$', ''
                    $selectedIndex = 0
                    $DrawMenu.Invoke($allOptions.Where({ $_ -like "*$fzInput*" }), $selectedIndex, $input)
                }
            }
            13 { # Enter
                if ($filteredOptions.Count -gt 0) {
                    Write-Host -NoNewline "`e[?1049l"
                    Write-Host $filteredOptions
                    return $filteredOptions[$selectedIndex]
                }
            }
            default {
                # 入力された文字をフィルタリング文字列に追加
                if ($key.Character -match '\S') {
                    $input += $key.Character
                    $fzInput = $input -replace '(.)', '$1*' -replace '\*$', ''
                    $selectedIndex = 0
                    $DrawMenu.Invoke($allOptions.Where({ $_ -like "*$fzInput*" }), $selectedIndex, $input)
                }
            }
        }
    }
} finally {
    # オルタネイトバッファを無効化して元に戻る
    Write-Host -NoNewline "`e[?1049l"
}

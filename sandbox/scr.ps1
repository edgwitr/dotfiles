function Read-UserInputWithDefault {
  param(
      [string]$Prompt,
      [string]$Default = "default"
  )
  Write-Host $Prompt "（何も入力しなければ`$Default`を使用）:"
  $inputStr = Read-Host
  if ([string]::IsNullOrEmpty($inputStr)) {
      return $Default
  } else {
      return $inputStr
  }
}

function Show-FilteredMenu {
  param(
      [string[]]$Items
  )
  $filteredItems = $Items
  $selectedIndex = 0
  $filterString = ""

  # 初回表示（ここで現在カーソル位置を記憶）
  Write-Host "内容を選択してください（上下矢印で選択、文字入力でフィルタ、Enterで決定）："
  $startLine = [Console]::CursorTop
  # フィルタ文字列表示行はここから
  Write-Host "フィルタ中の文字列："
  Write-Host ""  # 空行
  # アイテム表示開始行
  $itemStartLine = [Console]::CursorTop

  # 描画更新用関数（クリアはせず、同じ位置に上書き）
  function Refresh-Menu {
      # 現在カーソル位置を保持
      $currentCursorLeft = [Console]::CursorLeft
      $currentCursorTop = [Console]::CursorTop

      # フィルタ行へ戻る
      [Console]::SetCursorPosition(0, $startLine)
      # フィルタ状況表示行書き換え
      Write-Host ("フィルタ中の文字列： " + $filterString + "    ")  # 余白で前回表示を上書き
      Write-Host ""  # 空行(上書き)

      # アイテム表示開始行へ
      [Console]::SetCursorPosition(0, $itemStartLine)

      # 一旦、現在の項目一覧が減った場合に残りを上書き消去するため
      # 前回表示より行数が減った場合用に最大行数を記憶する
      # ここでは単純に、現在の表示数と過去の表示数を比べるため変数をスクリプト外に出すか、
      # 常に余分な空白行を出してクリアする。
      # 簡易実装として、一度全表示行を空白で上書きしてから再描画する
      $consoleWidth = [Console]::WindowWidth
      $blankLine = " " * ($consoleWidth - 1)
      for ($clearLine = 0; $clearLine -lt [math]::Max($filteredItems.Count, $Items.Count); $clearLine++) {
          Write-Host $blankLine
      }
      # 再度アイテム開始行へ戻ってアイテム描画
      [Console]::SetCursorPosition(0, $itemStartLine)

      for ($i = 0; $i -lt $filteredItems.Count; $i++) {
          if ($i -eq $selectedIndex) {
              Write-Host "> $($filteredItems[$i])" -ForegroundColor Cyan
          } else {
              Write-Host "  $($filteredItems[$i])"
          }
      }

      # 再度カーソル位置を元に戻さなくても良いが、ここでは不要
      #[Console]::SetCursorPosition($currentCursorLeft, $currentCursorTop)
  }

  Refresh-Menu

  while ($true) {
      $key = [System.Console]::ReadKey($true)
      switch ($key.Key) {
          "UpArrow" {
              if ($filteredItems.Count -gt 0) {
                  $selectedIndex = ($selectedIndex - 1)
                  if ($selectedIndex -lt 0) {
                      $selectedIndex = $filteredItems.Count - 1
                  }
              }
              Refresh-Menu
          }
          "DownArrow" {
              if ($filteredItems.Count -gt 0) {
                  $selectedIndex = ($selectedIndex + 1) % $filteredItems.Count
              }
              Refresh-Menu
          }
          "Enter" {
              if ($filteredItems.Count -gt 0) {
                  return $filteredItems[$selectedIndex]
              }
          }
          "Backspace" {
              if ($filterString.Length -gt 0) {
                  $filterString = $filterString.Substring(0, $filterString.Length - 1)
                  $filteredItems = $Items | Where-Object { $_ -like "*$filterString*" }
                  if ($filteredItems.Count -gt 0) {
                      $selectedIndex = 0
                  } else {
                      $selectedIndex = -1
                  }
                  Refresh-Menu
              }
          }
          default {
              # 通常の文字入力
              if ($key.KeyChar -and [char]::IsControl($key.KeyChar) -eq $false) {
                  $filterString += $key.KeyChar
                  $filteredItems = $Items | Where-Object { $_ -like "*$filterString*" }
                  if ($filteredItems.Count -gt 0) {
                      $selectedIndex = 0
                  } else {
                      $selectedIndex = -1
                  }
                  Refresh-Menu
              }
          }
      }
  }
}

# メイン処理
$filename = Read-UserInputWithDefault "ファイル名を入力してください" "default"
$choice = Show-FilteredMenu -Items @("brave","illness","panda")

Set-Content -Path $filename -Value $choice
Write-Host "ファイル${filename}に${choice}が出力されました。"

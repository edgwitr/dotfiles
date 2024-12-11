# 非エスケープシーケンスベースのコンソール操作用関数
function Write-CenteredText {
  param(
      [string]$Text
  )
  $left = [Console]::WindowWidth/2 - ($Text.Length/2)
  if ($left -lt 0) { $left = 0 }
  [Console]::SetCursorPosition($left, [Console]::CursorTop)
  Write-Host $Text
}

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

# 簡易メニュー選択関数（上下矢印で移動、タイプしてフィルタ、Enterで決定）
function Show-FilteredMenu {
  param(
      [string[]]$Items
  )
  # 初期状態
  $filteredItems = $Items
  $selectedIndex = 0
  $filterString = ""

  # コンソール表示更新用関数
  function Refresh-Menu {
      [Console]::Clear()
      Write-Host "内容を選択してください（上下矢印で選択、文字入力でフィルタ、Enterで決定）："
      Write-Host "フィルタ中の文字列：" $filterString
      Write-Host ""
      for ($i = 0; $i -lt $filteredItems.Count; $i++) {
          if ($i -eq $selectedIndex) {
              # 選択中の項目を強調表示（逆転色や前景色変更など）
              Write-Host "> " -NoNewline
              Write-Host ($filteredItems[$i]) -ForegroundColor Cyan
          } else {
              Write-Host "  $($filteredItems[$i])"
          }
      }
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
              # フィルタでアイテムが0件の場合、Enterで何もしない
          }
          "Backspace" {
              if ($filterString.Length -gt 0) {
                  $filterString = $filterString.Substring(0, $filterString.Length - 1)
              }
              $filteredItems = $Items | Where-Object { $_ -like "*$filterString*" }
              if ($filteredItems.Count -gt 0) {
                  $selectedIndex = 0
              } else {
                  $selectedIndex = -1
              }
              Refresh-Menu
          }
          default {
              # 文字キーによるフィルタリング
              if ($key.KeyChar -and $key.KeyChar -match '\S') {
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
$choice = Show-FilteredMenu -Items @("brave","illness")

# ファイル出力
Set-Content -Path $filename -Value $choice
Write-Host "`nファイル`$filenameに`$choiceが出力されました。"

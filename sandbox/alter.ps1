# オルタネイトバッファを有効化
Write-Host -NoNewline ([char]0x1b + "[?1049h")
[Console]::Clear()
# 専用画面を描画
for ($i = 0; $i -lt 10; $i++) {
    Write-Host "This is line $i"
    Start-Sleep -Milliseconds 200
}

# オルタネイトバッファを無効化して元に戻る
Write-Host -NoNewline ([char]0x1b + "[?1049l")

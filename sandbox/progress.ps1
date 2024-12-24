# 進捗バーの例
for ($i = 1; $i -le 100; $i++) {
    Write-Host "`r進捗: $i% " -NoNewline
    Start-Sleep -Milliseconds 50
}
Write-Host "`n完了！"

$global:LastGitStatusUpdateTime = Get-Date
$global:GitStatusResult = @()

function Get-GitStatusAsync {
  Start-Job -ScriptBlock {
    $result = git status --porcelain --branch 2> $null
    if ($null -eq $result) { return }

    $global:GitStatusResult = $result -split "`n"
    $global:LastGitStatusUpdateTime = Get-Date
  } | Out-Null  # async
}



Get-GitStatusAsync

function prompt {
  # if (((Get-Date) - $global:LastGitStatusUpdateTime).TotalSeconds -ge 1) { Get-GitStatusAsync }
  Write-Host "`n$(Get-Date -Format "yyyy-MM-dd HH:mm")" -NoNewline -ForegroundColor Cyan

  $currentPath = $executionContext.SessionState.Path.CurrentLocation
  $currentPath = $currentPath -replace [regex]::Escape($HOME), '~'
  Write-Host " [$currentPath]" -NoNewline -ForegroundColor Cyan

  Write-Host "`n$([System.Environment]::UserName)" -NoNewline -ForegroundColor Green
  Write-Host "@$([System.Net.Dns]::GetHostName())" -NoNewline -ForegroundColor Red
  Write-Host "$" -NoNewline
  return " "
}

$gitfile = Join-Path -Path $HOME -ChildPath ".cache/gitstatus.json"
$gitLatestUpdate = Get-Date
$gitBranch = {
  $currentPath = (Get-Location).Path
  while ($currentPath -ne (Get-Item $currentPath).PSDrive.Root) {
    if (Test-Path "$currentPath/.git") {
      $gitDir = "$currentPath/.git"
      if (-not (Test-Path -PathType Container $gitDir)) {
        $gitDir = Get-Content $gitDir
      }
      $headPath = "$gitDir/HEAD"
      if (Test-Path $headPath) {
        $branchRef = Get-Content $headPath
        if ($branchRef -match "ref: refs/heads/(.+)") {
          return "[$($matches[1])]"
        } else {
          return "*$branchRef*"
        }
      } else {
        return "Error: .git/HEAD not found or unreadable"
      }
    }
    $currentPath = [System.IO.Path]::GetDirectoryName($currentPath)
  }
}

function Write-GitStatusAsync {
  if ((Get-Date).AddSeconds(-1) -lt $gitLatestUpdate) {
    return
  } else {
    $gitLatestUpdate = Get-Date
  }
  $scriptBlock = {
      param($currentLocation, $targetPath)
      Set-Location $currentLocation
      $gitInfo = @{
        "status" = (git status --porcelain --branch 2> $null) -Split "`n"
        "stash" = (git stash list 2> $null) -Split "`n"
      }
      $gitInfo | ConvertTo-Json > $targetPath
  }

  $ps = [PowerShell]::Create()
  $ps.AddScript($scriptBlock).AddArgument((Get-Location).Path).AddArgument($gitfile) > $null

  $ps.BeginInvoke() > $null
}

function GitStatusConvert {
  param($status)
  if ($status) {
    $status = $status | ConvertFrom-Json
  } else {
    return ""
  }
  $sign = [ordered]@{}
  if ($status.status[0] -match "behind") {
    $sign.Add("<","0")
  } elseif ($status.status[0] -match "ahead") {
    $sign.Add(">","0")
  }

  $addsign = {
    param($sign, $statusString, $mark, $matchString)
    if (-not $sign.Contains($mark)) {
      if ($statusString -match $matchString) {
        $sign.Add($mark, 0)
      }
    }
  }

  for ($i = 1; $i -lt $status.status.count; $i++) {
    $addsign.Invoke($sign, $status.status[$i], "?", "^\?\? ")
    $addsign.Invoke($sign, $status.status[$i], "+", "^[MA][ MTD] ")
    $addsign.Invoke($sign, $status.status[$i], "!", "^[ MTARC]M ")
    $addsign.Invoke($sign, $status.status[$i], "x", "^[ MTARC]D ")
    $addsign.Invoke($sign, $status.status[$i], "»", "^R[ MTD] ")
    $addsign.Invoke($sign, $status.status[$i], "X", "^D  ")
    $addsign.Invoke($sign, $status.status[$i], "=", "^UU ")
  }
  if ($status.stash.count -gt 0) {
    $sign.Add("`${$($status.stash.count)}","0")
  }
  $result = $sign.Keys -Join ""
  return $result
}

function prompt {
  Write-Host "`n$(Get-Date -Format "yyyy-MM-dd HH:mm")" -NoNewline -ForegroundColor Cyan

  $currentPath = $executionContext.SessionState.Path.CurrentLocation
  $currentPath = $currentPath -replace [regex]::Escape($HOME), '~'
  Write-Host " [$currentPath]" -NoNewline -ForegroundColor Cyan

  $gbr = & $gitBranch
  if ($gbr) {
    Write-Host " $gbr" -NoNewline -ForegroundColor Yellow
    Write-GitStatusAsync
    if (Test-Path $gitfile) {
      $gitstatus = GitStatusConvert (Get-Content $gitfile)
      if ($gitstatus) {
        Write-Host " ($gitstatus)" -NoNewline -ForegroundColor Magenta
      }
    }
  } else {
    Remove-Item $gitfile
  }

  Write-Host "`n$([System.Environment]::UserName)" -NoNewline -ForegroundColor Green
  Write-Host "@$([System.Net.Dns]::GetHostName())" -NoNewline -ForegroundColor Red

  $isAdmin = $false
  if ($global:winEnv) {
    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
  } else {
    $isAdmin = $env:USER -eq "root"
  }
  if ($isAdmin) {
    Write-Host "[#]" -NoNewline -ForegroundColor Red
  } else {
    Write-Host "$" -NoNewline
  }
  return " "
}

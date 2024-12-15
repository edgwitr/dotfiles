$gitfile = [System.IO.Path]::Combine($HOME, ".cache", "gitstatus.json")
$gitLatestUpdate = ""
$GetGitBranch = {
  # $gb = git rev-parse --short HEAD
  # if ($gb -eq "fatal: not a git repository (or any of the parent directories): .git") {
  #   $gb = git rev-parse --short HEAD 2> $null
  # }
  # return $gb
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
          return "$($matches[1])"
        } else {
          return "$branchRef"
        }
      } else {
        return "Error: .git/HEAD not found or unreadable"
      }
    }
    $currentPath = [System.IO.Path]::GetDirectoryName($currentPath)
  }
}

$WriteGitStatusAsync = {
  if ($gitLatestUpdate -eq "") {
    $gitLatestUpdate = Get-Date
  } else {
    if ((Get-Date).AddSeconds(-1) -lt $gitLatestUpdate) {
      return
    } else {
      $gitLatestUpdate = Get-Date
    }
  }
  $scriptBlock = {
      param($currentLocation, $targetPath)
      Set-Location $currentLocation
      @{
        "status" = (git status --porcelain --branch 2> $null) -Split "`n"
        "stash" = (git stash list 2> $null) -Split "`n"
        "hash" = (git rev-parse --short HEAD 2> $null)
      } | ConvertTo-Json > $targetPath
  }

  $ps = [PowerShell]::Create()
  $ps.AddScript($scriptBlock).AddArgument((Get-Location).Path).AddArgument($gitfile) > $null

  $ps.BeginInvoke() > $null
}

$ConvertGitBranch = {
  param($status, $gbr)
  if ($status) {
    $status = $status | ConvertFrom-Json
    if ($status.status[0] -eq "## HEAD (no branch)") {
      return $status.hash
    } else {
      if ($status.status[0] -match "^##\s+([^\.\s]+)(?:\.\.\.([^\s\[]+))?") {
        $branch = $matches[1]
        if ($matches[2]) {
          $branch += " -> $($matches[2])"
        }
        return $branch
      }
    }
  }
}

$ConvertGitStatus = {
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
  Write-Host "`n$(Get-Date -Format "yyyy-MM-dd HH:mm")" -NoNewline -ForegroundColor DarkGray
  $currentPath = $executionContext.SessionState.Path.CurrentLocation
  $currentPath = $currentPath -replace [regex]::Escape($HOME), '~'
  Write-Host "`n[$currentPath]" -NoNewline -ForegroundColor Cyan

  $gbr = & $GetGitBranch
  if ($gbr) {
    & $WriteGitStatusAsync
    $gitContent = Get-Content $gitfile -ErrorAction SilentlyContinue
    if ($gitContent) {
      $gitBranch = & $ConvertGitBranch $gitContent $gbr
      if ($gitBranch) {
        Write-Host " $gitBranch" -NoNewline -ForegroundColor DarkYellow
        $gitStatus = & $ConvertGitStatus $gitContent
        if ($gitStatus) {
          Write-Host " ($gitStatus)" -NoNewline -ForegroundColor Magenta
        }
      }
    } else {
      Write-Host " $gbr" -NoNewline -ForegroundColor DarkYellow
    }
  } else {
    Remove-Item $gitfile
  }

  Write-Host "`n$([System.Environment]::UserName)" -NoNewline -ForegroundColor Green
  Write-Host "@$([System.Net.Dns]::GetHostName())" -NoNewline -ForegroundColor Red

  $isAdmin = $false
  if ($env:OSTYPE) {
    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
  } else {
    $isAdmin = $env:USER -eq "root"
  }
  if ($isAdmin) {
    Write-Host "#" -NoNewline -ForegroundColor Yellow
  } else {
    Write-Host "$" -NoNewline
  }
  return " "
}

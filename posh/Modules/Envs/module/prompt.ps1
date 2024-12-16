$gitfile = [System.IO.Path]::Combine($HOME, ".cache", "gitstatus.json")
$gitLatestUpdate = ""
$GetGitBranch = {
  $currentPath = (Get-Location).Path
  while ($currentPath -ne (Get-Item $currentPath).PSDrive.Root) {
    if (Test-Path "$currentPath/.git") {
      $env:GITROOT = $currentPath
      $gitDir = "$currentPath/.git"
      if (-not (Test-Path -PathType Container $gitDir)) {
        $gitDir = Get-Content $gitDir
      }
      $headPath = "$gitDir/HEAD"
      if (Test-Path $headPath) {
        $branchRef = Get-Content $headPath
        if ($branchRef -match "ref: refs/heads/(.+)") {
          return $matches[1]
        } else {
          return $branchRef
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
        "stash" = (Get-Content "$env:GITROOT/.git/logs/refs/stash" -ErrorAction SilentlyContinue) -Split "`n"
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
      return $gbr
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
    for ($i = 1; $i -lt $statusString.count; $i++) {
      if ($statusString[$i] -match $matchString) {
        $sign.Add($mark, 0)
        break
      }
    }
  }

  $addsign.Invoke($sign, $status.status, "=", "^UU ")
  $addsign.Invoke($sign, $status.status, "?", "^\?\? ")
  $addsign.Invoke($sign, $status.status, "!", "^[ MTARC]M ")
  $addsign.Invoke($sign, $status.status, "+", "^[MA][ MTD] ")
  $addsign.Invoke($sign, $status.status, "x", "^[ MTARC]D ")
  $addsign.Invoke($sign, $status.status, "X", "^D  ")
  $addsign.Invoke($sign, $status.status, "»", "^R[ MTD] ")

  if ($status.stash.count -gt 0) {
    $sign.Add(" `$$($status.stash.count)","0")
  }
  $result = $sign.Keys -Join ""
  return $result
}

function prompt {
  $currentPath = $executionContext.SessionState.Path.CurrentLocation
  $currentPath = $currentPath -replace [regex]::Escape($HOME), '~'

  $gbr = & $GetGitBranch
  if ($gbr) {
    & $WriteGitStatusAsync
    $gitContent = Get-Content $gitfile -ErrorAction SilentlyContinue
    if ($gitContent) {
      $gitBranch = & $ConvertGitBranch $gitContent $gbr
      if ($gitBranch) {
        $gbr = $gitBranch
        $gitStatus = & $ConvertGitStatus $gitContent
      }
    }
  } else {
    Remove-Item $gitfile -ErrorAction SilentlyContinue
    $env:GITROOT = $null
  }

  $userName = [System.Environment]::UserName
  $hostName = [System.Net.Dns]::GetHostName()

  $isAdmin = $false
  if ($env:OSTYPE -eq "win") {
    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
  } else {
    $isAdmin = $env:USER -eq "root"
  }

  Write-Host "`n$(Get-Date -Format "yyyy-MM-dd HH:mm")" -NoNewline
  Write-Host "`n[$currentPath]" -NoNewline -ForegroundColor Cyan

  if ($gbr) {
    Write-Host " $gbr" -NoNewline -ForegroundColor Yellow
    if ($gitStatus) {
      Write-Host " ($gitStatus)" -NoNewline -ForegroundColor Magenta
    }
  }
  if ($isAdmin) {
    Write-Host "`n$userName@$hostName #" -NoNewline -ForegroundColor Red
  } else {
    Write-Host "`n$userName@$hostName $" -NoNewline -ForegroundColor Green
  }
  return " "
}

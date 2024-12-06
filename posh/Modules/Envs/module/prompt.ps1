function Get-GitBranch {
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
          return $matches[1]
        } else {
          return "detached HEAD at $branchRef"
        }
      } else {
        return "Error: .git/HEAD not found or unreadable"
      }
    }
    $currentPath = Split-Path -Path $currentPath -Parent
  }
}

$gitfile = Join-Path -Path $HOME -ChildPath ".cache/gitstatus.txt"

function Write-GitStatusAsync {
  $scriptBlock = {
      param($currentLocation, $targetPath)
      Set-Location $currentLocation
      (git status --porcelain 2> $null) > $targetPath
  }

  $ps = [PowerShell]::Create()
  $ps.AddScript($scriptBlock).AddArgument((Get-Location).Path).AddArgument($gitfile) > $null

  $asyncResult = $ps.BeginInvoke()
}

function prompt {
  Write-Host "`n$(Get-Date -Format "yyyy-MM-dd HH:mm")" -NoNewline -ForegroundColor Cyan

  $currentPath = $executionContext.SessionState.Path.CurrentLocation
  $currentPath = $currentPath -replace [regex]::Escape($HOME), '~'
  Write-Host " [$currentPath]" -NoNewline -ForegroundColor Cyan

  $gst = Get-GitBranch
  if ($gst) {
    Write-Host " $gst" -NoNewline -ForegroundColor Yellow
    Write-GitStatusAsync
    if (Test-Path $gitfile) {
      $gitstatus = Get-Content $gitfile
      Write-Host " $gitstatus" -NoNewline -ForegroundColor Red
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
    Write-Host "#" -NoNewline -ForegroundColor Yellow
  } else {
    Write-Host "$" -NoNewline
  }
  return " "
}

function Show-DirectoryTree {
  param (
      [string]$Path = ".",
      [switch]$IncludeHidden = $false,
      [switch]$IncludeFiles = $false
  )
  $separator = [System.IO.Path]::DirectorySeparatorChar
  $Path = (Get-Item $Path).FullName + $separator
  $targets = if ($IncludeHidden -and $IncludeFiles) {
    Get-ChildItem -Path $Path -Recurse -Force
  } elseif ($IncludeHidden) {
    Get-ChildItem -Path $Path -Recurse -Directory -Force
  } elseif ($IncludeFiles) {
    Get-ChildItem -Path $Path -Recurse
  } else {
    Get-ChildItem -Path $Path -Recurse -Directory
  }
  $targets = $targets | Sort-Object FullName

  function depth ([string]$targetPath) {
    $depth = $targetPath.Split($separator).Count - 1
    return $depth
  }
  $pathDepth = depth $Path

  $result = for ($i = 0; $i -lt $targets.Count; $i++) {
    $current = $targets[$i].FullName
    $currentDepth = (depth $current) - $pathDepth
    $prefix = "  " * $currentDepth

    if (-not ($i -eq $targets.Count - 1)) {
      $next = $targets[$i + 1].FullName
      $nextDepth = (depth $next) - $pathDepth

      # echo "$currentDepth $nextDepth"
      if ($currentDepth -eq $nextDepth) {
        $prefix += "├─"
      } else {
        $prefix += "└─"
      }
    } else {
      $prefix += "└─"
    }

    Write-Output "$prefix$($targets[$i].Name)"
  }
  # $result
  $maxLength = $result | ForEach-Object { $_.Length } | Sort-Object -Descending | Select-Object -First 1
  $resultArray = [System.Collections.ArrayList]::new()
  $i = 0
  $result | ForEach-Object { $resultArray.Add($_.ToCharArray()) | Out-Null }
  for ($column = 0; $column -lt $maxLength; $column += 2) {
    $startFlag = $false
    for ($row = $result.Count; $row -gt 0; $row--) {
      if ($resultArray[$row].Count -gt $column) {
        if ($resultArray[$row][$column] -eq " " -and $resultArray[$row + 1][$column] -eq "└") {
          $startFlag = $true
        }
        if ($startFlag) {
          $resultArray[$row][$column] = "│"
        }
      }
    }
  }
  $resultArray | ForEach-Object { [string]::new($_) }
}


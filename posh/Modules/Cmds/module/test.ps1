$env:GITREPOROOT = [System.IO.Path]::Combine($HOME, ".local","git-repositories")
$env:GITREPOROOT = $env:GITREPOROOT + [System.IO.Path]::DirectorySeparatorChar
mkdir -Force $env:GITREPOROOT
class GitrootPath {
  [string]$Name
  [string]$Path
  [string]$FullPath
}

# required commands
$requireCmd = & {
  $existGIT = Get-Command git -ErrorAction SilentlyContinue
  $existGH = Get-Command gh -ErrorAction SilentlyContinue
  if (-not $existGIT -and -not $existGH) {
    return "git,gh"
  } elseif (-not $existGIT) {
    return "git"
  } elseif (-not $existGH) {
    return "gh"
  }
  return ""
}
function Get-GitRepository {
  [CmdletBinding()]
  [OutputType([string[]],[GitrootPath[]])]
  param(
    # clone
    [Alias("Get","g")]
    [Parameter(ParameterSetName='Clone', Mandatory=$true)]
    [switch]$Clone,
    [Alias("b")]
    [Parameter(ParameterSetName='Clone')]
    [string]$Branch,

    # create
    [Alias("c")]
    [Parameter(ParameterSetName='Create', Mandatory=$true)]
    [switch]$Create,
    [Parameter(ParameterSetName='Create')]
    [switch]$Bare,

    # remove
    [Alias("rm")]
    [Parameter(ParameterSetName='Remove', Mandatory=$true)]
    [switch]$Remove,
    [Parameter(ParameterSetName='Remove')]
    [switch]$DryRun,

    # list
    [Alias("l")]
    [Parameter(ParameterSetName='List', Mandatory=$true)]
    [switch]$List,
    [Alias("q")]
    [Parameter(ParameterSetName='List')]
    [string]$Query,

    # root directory
    [Alias("r")]
    [Parameter(ParameterSetName='Root', Mandatory=$true)]
    [switch]$Root,

    [Alias("Path")]
    [Parameter(ParameterSetName='Clone')]
    [Parameter(ParameterSetName='Remove', ValueFromPipeline=$true)]
    [Parameter(ParameterSetName='Create')]
    [string[]]$Repository

  )
  if ($requireCmd -ne "") {
    Write-Error "ERROR: $requireCmd is missing. Please install it and try again."
    return
  }

  switch ($PSCmdlet.ParameterSetName) {
    'Clone' {
      foreach ( $path in $Repository ) {
        Write-Host "Get : $path"
      }
    }
    'Create' {
      if ($Bare) {
        Write-Host "Creating bare repository: $Repository"
      } else {
        Write-Host "Creating repository: $Repository"
      }
    }
    'Remove' {
      if ($DryRun) {
        Write-Host "dry-run :"
        foreach ( $path in $Repository ) {
          Write-Host "$env:GITREPOROOT$path"
        }
      } else {
        Write-Host "remove :"
        foreach ( $path in $Repository ) {
          Write-Host "$env:GITREPOROOT$path"
          Remove-Item -Path "$env:GITREPOROOT$path" -Recurse -Force
        }
      }
    }
    'List' {
      $result = Get-ChildItem -Path $env:GITREPOROOT -Recurse -Directory | ForEach-Object {
        if (Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git")) {
          $path = $_.FullName
          if ($Query -ne "" -and $path -notmatch $Query) {
            break
          }
          [GitrootPath]@{
            Name = $_.Name
            Path = $path -replace [regex]::Escape($env:GITREPOROOT), ""
            FullPath = $path
          }
        }
      }
      return $result
    }
    'Root' {
      Write-Host $env:GITREPOROOT
    }
    default {
      Write-Error "ERROR: Invalid command."
    }
  }
}

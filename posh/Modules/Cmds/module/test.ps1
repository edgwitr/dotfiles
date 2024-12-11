$env:GRROOT = "$HOME/.local/git-repositories"
mkdir -Force $env:GRROOT
function Get-GitRepository {
  [CmdletBinding()]
  param(

    # create
    [Alias("Get","g")]
    [Parameter(ParameterSetName='Clone', Mandatory=$true)]
    [switch]$Clone,
    [Alias("b")]
    [Parameter(ParameterSetName='Clone')]
    [string]$Branch,

    [Alias("c")]
    [Parameter(ParameterSetName='Create', Mandatory=$true)]
    [switch]$Create,

    [Alias("rm")]
    [Parameter(ParameterSetName='Remove', Mandatory=$true)]
    [switch]$Remove,
    [Parameter(Position=1,ParameterSetName='Remove')]
    [switch]$DryRun,

    [Alias("l")]
    [Parameter(ParameterSetName='List', Mandatory=$true)]
    [switch]$List,
    [Alias("f")]
    [Parameter(ParameterSetName='List')]
    [switch]$FullPath,
    [Alias("q")]
    [Parameter(ParameterSetName='List')]
    [string]$Query,

    # return root directory
    [Alias("r")]
    [Parameter(ParameterSetName='Root', Mandatory=$true)]
    [switch]$Root,

    [Parameter(Position=1,ParameterSetName='Clone')]
    [Parameter(Position=1,ParameterSetName='Remove')]
    [Parameter(Position=1,ParameterSetName='Create')]
    [string]$Repository,

    [Parameter(ParameterSetName='Clone')]
    [Parameter(ParameterSetName='Create')]
    [switch]$Bare

  )

  # required commands
  $requiredCommands = @("gh", "git")

  foreach ($cmd in $requiredCommands) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
      Write-Error "ERROR: '$cmd' is missing. Please install it and try again."
      return
    }
  }

  switch ($PSCmdlet.ParameterSetName) {
    'Clone' {
      Write-Host "Clone : $Repository"
    }
    'Create' {
      if ($Bare) {
        Write-Host "Creating bare repository: $Repository"
      } else {
        Write-Host "Creating repository: $Repository"
      }
    }
    'Get' {
      Write-Host "Get : $Repository"
    }
    'List' {
      Get-ChildItem -Path $env:GRROOT -Recurse -Directory | ForEach-Object {
          if (Test-Path -Path (Join-Path -Path $_.FullName -ChildPath ".git")) {
            if ($FullPath) {
              Write-Output $_.FullName
            } else {
              Write-Output ($_.Name -replace "$HOME","")
            }
          }
      }
    }
    'Remove' {
      Write-Host "remove list"
    }
    'Root' {
      Write-Host $env:GRROOT
    }
    default {
      Write-Error "ERROR: Invalid command."
    }
  }
}

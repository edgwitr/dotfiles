$cd_original = Get-Command Set-Location
$cd_stack = [System.Collections.Stack]::new()
function Set-Location {
  [CmdletBinding(DefaultParameterSetName = 'Path', SupportsTransactions)]
  param (
    [Parameter(Position=0, ParameterSetName='Path', ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true, ParameterSetName='LiteralPath', ValueFromPipelineByPropertyName=$true)]
    [string]$LiteralPath,

    [switch]$PassThru
  )

  $params = @{}

  if ($PSBoundParameters.ContainsKey('Path')) {
    if ( $PSBoundParameters['Path'] -eq "-" ) {
      if ($cd_stack.Count -eq 0) { return "There's no turning back" }
      $params['Path'] = $cd_stack.Pop()
    } else {
      $cd_stack.Push((Get-Location).Path)
      $params['Path'] = $Path
    }
  } else {
    $cd_stack.Push((Get-Location).Path)
    if ($PSBoundParameters.ContainsKey('LiteralPath')) {
      $params['LiteralPath'] = $LiteralPath
    } else {
      $params['Path'] = $HOME
    }
  }

  if ($PSBoundParameters.ContainsKey('PassThru')) {
    $params['PassThru'] = $PassThru
  }

  if ($PSBoundParameters.ContainsKey('UseTransaction')) {
    $params['UseTransaction'] = $UseTransaction
  }
  
  & $cd_original @params
}

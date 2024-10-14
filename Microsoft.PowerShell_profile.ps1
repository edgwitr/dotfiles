using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$_ealiases = [ordered]@{}
$_placeHolder = "%"

function _lookup_ealias([string]$Name) {
  $metadata = $_ealiases[$Name]
  return $null -eq $metadata ? $null : $metadata.ExpandsTo
}
function ealias() {
  param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$ExpandsTo,
    [Parameter(Mandatory = $false)][switch]$NoSpaceAfter = $false,
    [Parameter(Mandatory = $false)][int]$Placeholders = 0,
    [Parameter(Mandatory = $false)][switch]$Anywhere = $false
  )

  Set-Alias $Name "$ExpandsTo" -Scope Global

  $_ealiases[$Name] = @{
    ExpandsTo    = $ExpandsTo
    NoSpaceAfter = $NoSpaceAfter
    Placeholders = $Placeholders
    Anywhere     = $Anywhere
  }

}

function ExpandAliasBeforeCursor ($key, $arg) {

  [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
  $ast = $null
  $tokens = $null
  $errors = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

  $startAdjustment = 0

  foreach ($token in $tokens) {
    $original = $token.Extent

    $metadata = $_ealiases[$original.Text]
    if ($null -eq $metadata -or $null -eq $metadata.ExpandsTo) {
      continue
    }

    $anywhere = $metadata.Anywhere
    $is_command_position = $token -eq $tokens[0]
    if (-not $anywhere -and -not $is_command_position) {
      continue
    }

    $expands_to = $metadata.ExpandsTo

    if (-not $metadata.NoSpaceAfter) {
      $expands_to = "$expands_to "
    }

    
    $original_length = $original.EndOffset - $original.StartOffset
    $placeholders = $metadata.Placeholders

    # 複数プレースホルダ対応
    $placeholderIndex = 0
    for ($i = 0; $i -lt $placeholders; $i++) {
      $placeholderIndex = $expands_to.IndexOf("%")
      if ($placeholderIndex -ge 0) {
        $expands_to = $expands_to.Substring(0, $placeholderIndex) + $expands_to.Substring($placeholderIndex + 1)
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
          $original.StartOffset + $startAdjustment,
          $original_length,
          $expands_to
        )
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($original.StartOffset + $startAdjustment + $placeholderIndex)
        $startAdjustment += $expands_to.Length - $original_length
  
        # 次のプレースホルダがある場合、入力待ち
        if ($i -lt $placeholders - 1) {
          # ReadKeyでユーザーからの入力待ち
          $keyInfo = [Console]::ReadKey()
          while ($keyInfo.Key -ne [ConsoleKey]::Spacebar) {
            # Spacebar以外のキーが入力された場合は、通常の入力処理
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($keyInfo.KeyChar)
            $startAdjustment += 1
            $keyInfo = [Console]::ReadKey()
          }
          $startAdjustment += 1 # +1 for the space
        }
      } else {
        break
      }
    }
    # $placeholderIndex = $expands_to.IndexOf($_placeHolder)
    # if ($placeholderIndex -ge 0) {
    #   $expands_to = $expands_to.Substring(0, $placeholderIndex) + $expands_to.Substring($placeholderIndex + 1)
    # }

    # $original_length = $original.EndOffset - $original.StartOffset
    # [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
    #   $original.StartOffset + $startAdjustment,
    #   $original_length,
    #   $expands_to
    # )

    # if ($placeholderIndex -ge 0) {
    #   [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($original.StartOffset + $startAdjustment + $placeholderIndex)
    # }

    # $startAdjustment += $expands_to.Length - $original_length

  }
}

Set-PSReadLineKeyHandler -Key "Spacebar" -ScriptBlock ${function:ExpandAliasBeforeCursor}
Set-PSReadLineKeyHandler -Key Enter -Function ValidateAndAcceptLine

function ExpandAliasesCommandValidationHandler([CommandAst]$CommandAst) {
  $metadata = $_ealiases[$CommandAst.GetCommandName()]
  if ($null -eq $metadata) {
    return
  }
  $expands_to = $metadata.ExpandsTo

  $original = $CommandAst.CommandElements[0].Extent
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
    $original.StartOffset,
    $original.EndOffset - $original.StartOffset,
    $expands_to
  )

}

Set-PSReadLineOption -CommandValidationHandler ${function:ExpandAliasesCommandValidationHandler}


ealias gst 'git status'
ealias gco 'git commit -m "%"' -NoSpaceAfter -Placeholders 1
ealias gsgs 'a "%" b "%"' -NoSpaceAfter -Placeholders 2
ealias dcpsa 'docker container ps -a'
ealias dcri 'docker container run --rm -i -t'
ealias kgp 'kubectl get pods'
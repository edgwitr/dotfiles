using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$_abbrs = [ordered]@{}
$_placeHolder = "%"

function _lookup_ealias([string]$Name) {
  $metadata = $_abbrs[$Name]
  return if (-not $null -eq $metadeta) { $metadata.ExpandsTo }
}
function Set-Abbr() {
  param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$ExpandsTo,
    [Parameter(Mandatory = $false)][switch]$NoSpaceAfter = $false,
    [Parameter(Mandatory = $false)][switch]$Anywhere = $false
  )

  Set-Alias $Name "$ExpandsTo" -Scope Global

  $_abbrs[$Name] = @{
    ExpandsTo    = $ExpandsTo
    NoSpaceAfter = $NoSpaceAfter
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

    $metadata = $_abbrs[$original.Text]
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
    $placeholders = ($expands_to | Select-String -Pattern "%" -AllMatches).Matches.Count

    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
      $original.StartOffset + $startAdjustment,
      $original_length,
      $expands_to
    )
    if ($placeholders -eq 0) {
      continue
    }

    $placeholderIndex = 0
    $now_console = $expands_to
    for ($i = 0; $i -lt $placeholders; $i++) {
      $placeholderIndex = $now_console.IndexOf($_placeHolder)
      $head = $now_console.Substring(0, $placeholderIndex)
      $tail = $now_console.Substring($placeholderIndex + 1)
      $now_console = $head + $tail
      [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
        $placeholderIndex,
        $tail.Length + 1,
        $tail
      )
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($placeholderIndex)

      # next place-holder
      if ($i -lt $placeholders - 1) {
        $keyInfo = [Console]::ReadKey()
        while ($keyInfo.Key -ne [ConsoleKey]::Tab) {
          switch ($keyInfo.Key) {
            Enter { [Microsoft.PowerShell.PSConsoleReadLine]::AccptLine() }
            Backspace {
              [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
              [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar()
            }
            Delete { [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar() }
            LeftArrow { [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar() }
            RightArrow { [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar() }
            UpArrow { return }
            DownArrow { return }
            default {
              [Microsoft.PowerShell.PSConsoleReadLine]::Insert($keyInfo.KeyChar)
              $now_console = $now_console.Substring(0, $placeholderIndex) + $keyInfo.KeyChar + $now_console.Substring($placeholderIndex)
              $placeholderIndex++
            }
          }
          $keyInfo = [Console]::ReadKey()
        }
      }
    }
  }
}

Set-PSReadLineKeyHandler -Key "Spacebar" -ScriptBlock ${function:ExpandAliasBeforeCursor}
Set-PSReadLineKeyHandler -Key Enter -Function ValidateAndAcceptLine

function ExpandAliasesCommandValidationHandler([CommandAst]$CommandAst) {
  $metadata = $_abbrs[$CommandAst.GetCommandName()]
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

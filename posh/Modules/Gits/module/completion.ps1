Register-ArgumentCompleter -CommandName git -ScriptBlock {
  param(
    [String]$wordToComplete, 
    [System.Management.Automation.Language.CommandAst]$commandAst,
    [System.Object]$parameterName,
    [System.Object]$cursorPosition
  )
  if ($commandAst.CommandElements.Count -gt 2) { return }
  if ($commandAst.CommandElements.Count -eq 2 -and $wordToComplete -eq "") { return }

  $subcommands = (git --list-cmds=main)
  $match_list = $subcommands | Where-Object { $_ -like "$wordToComplete*" }

  $match_list | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

function Invoke-MyCustomTool {
  [CmdletBinding()]
  param(
      [Parameter(Position=0, Mandatory=$true)]
      [ValidateSet(
        'add',
        'commit',
        'push',
        'status'
      )]
      [string]$Command,

      [Parameter(Position=1, ValueFromRemainingArguments=$true)]
      [string[]]$CommandArguments
  )

  switch ($Command) {
      'add' {
          # git addのような動作
          Write-Host "Adding files: $($CommandArguments -join ' ')"
          # 実際の追加処理をここに記述
      }
      'commit' {
          # git commitのような動作
          $message = $CommandArguments -join ' '
          Write-Host "Committing with message: $message"
          # 実際のコミット処理をここに記述
      }
      'push' {
          Write-Host "Pushing changes"
          # プッシュ処理
      }
      'status' {
          Write-Host "Showing status"
          # ステータス表示処理
      }
  }
}

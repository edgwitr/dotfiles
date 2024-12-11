# function Get-GitRepository {
#   [CmdletBinding()]
#   param(
#     [Parameter(Position=0, Mandatory=$true)]
#     [ValidateSet(
#       'create',
#       'clone',
#       'get',
#       'list',
#       'remove',
#       'root'
#     )]
#     [string]$Command,

#     [Parameter(Position=1, ValueFromRemainingArguments=$true)]
#     [string[]]$CommandArguments
#   )
#   # required commands
#   $requiredCommands = @("gh", "git")

#   foreach ($cmd in $requiredCommands) {
#     if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
#       Write-Error "ERROR: '$cmd' is missing. Please install it and try again."
#       return
#     }
#   }

#   switch ($Command) {
#     'create' {
#       Write-Host "Creating new repository"
#       # 新規リポジトリ作成処理
#     }
#     'clone' {
#       Write-Host "Cloning repository: $($CommandArguments[0])"
#       # クローン処理
#     }
#     'get' {
#       Write-Host "Getting repository: $($CommandArguments[0])"
#       # リポジトリ取得処理
#     }
#     'list' {
#       Write-Host "Listing repositories"
#       # リポジトリ一覧表示処理
#     }
#     'remove' {
#       Write-Host "Removing repository: $($CommandArguments[0])"
#       # リポジトリ削除処理
#     }
#     'root' {
#       Write-Host "Showing root directory"
#       # ルートディレクトリ表示処理
#     }
#     default {
#       Write-Error "ERROR: Invalid command '$Command'."
#     }
#   }
# }

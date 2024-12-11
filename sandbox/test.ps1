function Get-CustomData {
  [CmdletBinding()]
  param (
      [string]$Name,
      [int]$Age
  )
  [PSCustomObject]@{
      Name = $Name
      Age  = $Age
  }
}

# オブジェクトを返すので、パイプラインで他のコマンドと組み合わせられる
Get-CustomData -Name "John" -Age 30 | Where-Object {$_.Age -gt 20}

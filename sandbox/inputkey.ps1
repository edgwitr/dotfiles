[Console]::TreatControlCAsInput = $true  # Ctrl + C を割り込みとして扱わないようにする
while ($true) {
  $key = [Console]::ReadKey($true)
  switch ($key.Modifiers) {
    Control {
      switch ($key.Key) {
        C {
          return
        }
        default {
          echo $key.Key
        }
      }
    }
    default {
      echo $key.Modifiers
      echo $key.Key
    }
  }
  echo hoge
}

# PowerShellでマウスポインタの座標を取得する

# アセンブリのロード
Add-Type -AssemblyName System.Windows.Forms

# フォームの作成・ボタンの作成
$form = New-Object System.Windows.Forms.Form
$form.Size = "200,200"
$form.StartPosition = "CenterScreen"

$Button = New-Object System.Windows.Forms.Button
$Button.Location = "50,50"
$Button.Size = "100,50"
$Button.Text = "クリック！"

# クリックイベント
$click = {
    for ( $a = 0 ; $a -lt 10 ; $a++ )
    {
        $x = [System.Windows.Forms.Cursor]::Position.X # マウスのX座標
        $y = [System.Windows.Forms.Cursor]::Position.Y # マウスのY座標
        Write-Host "マウスの現在座標は($x,$y)です"
        Start-Sleep(1)
    }
    Write-Host "終わり"
}
$Button.Add_Click($click)

$form.Controls.Add($Button)
$Form.Showdialog()

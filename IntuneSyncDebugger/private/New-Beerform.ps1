function New-BeerForm {
    param(
        [switch]$Unattended
    )
    $path = "C:\temp"
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force -Confirm:$false
    }
    $img = Invoke-WebRequest -Uri "https://call4cloud.nl/wp-content/uploads/2022/09/487ba55465e8cf5ff78ea5bf8cf06e4a.gif" -OutFile "$path\membeer.gif" -ErrorAction:Stop

    Add-Type -AssemblyName System.Windows.Forms
    $Form = New-Object System.Windows.Forms.Form
    $Form.AutoSize = $true
    $Form.StartPosition = "CenterScreen"

    $Form.Text = "Membeer Player"
    $Label = New-Object System.Windows.Forms.Label
    $Label.Location = New-Object System.Drawing.Size(0, 0)
    $Label.AutoSize = $true
    $Label.Font = New-Object System.Drawing.Font ("Comic Sans MS", 20, [System.Drawing.Fontstyle]::Bold)
    $Label.Text = "MDE Successful!"
    $Form.Controls.Add($Label)

    $gifBox = New-Object Windows.Forms.picturebox
    $gifLink = (Get-Item -Path 'C:\temp\membeer.gif')
    $img = [System.Drawing.Image]::fromfile($gifLink)
    $gifBox.AutoSize = $true
    $gifBox.Image = $img
    $Form.Controls.Add($gifbox)
}